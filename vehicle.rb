require 'byebug'
require 'json'
require 'typhoeus'
require 'open-uri'
require 'oj'
require 'geometry'

def post_track(body)
	response = Typhoeus.post("localhost:3000/tracks",  headers: {'Content-Type'=> "application/json"}, body: body)
	#byebug
end

def get_url_json(url)

	max_http = 2
	max_timeouts = 10
	response = nil
	success = false
	loop do
		response = Typhoeus.get(url, timeout: 5, connecttimeout:5)

		if response.success?
			break
		elsif response.timed_out? || response.code == 0
			puts "Timeout or no code #{url} #{max_timeouts}"
			max_timeouts = max_timeouts - 1
			sleep 2
		else
			puts "HTTP error code for #{url} was #{response.code.to_s} #{max_http}"
			max_http = max_http - 1
		end
	
		if max_http == 0 || max_timeouts==0
			$stderr.puts "Maxerrors achieved for #{url} HTTP:#{max_http} TO:#{max_timeouts}" 
			return nil
		end
	end
	Oj.load(response.body)
end

class Calculator
	def initialize(values)
		@values = values
		@values_sorted = @values.sort
		@sum = 0
		@values.each { |v| @sum += v }
		@avg = @sum / @values.length
	end

	def max
		@values_sorted.last
	end

	def min
		@values_sorted.first
	end

	def avg
		@avg
	end

	def percentile(percentile)
		if percentile == 1
			return @values_sorted.last
		end
    	k = (percentile*(@values_sorted.length-1)+1).floor - 1
    	f = (percentile*(@values_sorted.length-1)+1).modulo(1)
    	return @values_sorted[k] + (f * (@values_sorted[k+1] - @values_sorted[k]))
    end
end


class CarVector
	attr_accessor :x, :y, :m, :h

	def initialize(x, y)
		@x= x
		@y= y
		@m = @y/@x
		@h = Math.sqrt ((@x**2) + (@y**2))
	end

	def with_h(h)
		x = Math.sqrt(h**2/((@m**2) + 1))
		if @x < 0
			x = (-x)
		end
		y = @m * x
		CarVector.new(x, y)
	end

	def minus(v2)
		x = @x-v2.x
		y = @y-v2.y
		CarVector.new(x, y)
	end

	def plus(v2)
		x = @x+v2.x
		y = @y+v2.y
		CarVector.new(x, y)
	end

	def to_s
		"#{@x},#{@y}"
	end
end

class Line
	attr_accessor :distance_ratio, :pend

	def initialize(v0, v1, distance)
		@v0 = v0
		@v1 = v1
		@vd = v1.minus(v0)
		@distance_ratio = @vd.h / distance
	end

	def get_coordinates_at(distance)
 		 h = distance_ratio * distance
 		 vh = @vd.with_h(h)
 		 @v0.plus(vh)
	end
end


class Vehicle
	attr_accessor :current_position, :current_time

	#Initialize the vehicle
	def initialize(serial_no, start_date, starting_position)
		@current_time = start_date
		@since_last = 0
		@serial_no = serial_no
		@current_speed = 0
		@rnd = Random.new(Time.now.to_i)
		@current_position = starting_position
		empty_records
	end

	# Drive to a given location in this estimated period of time
	def drive_to(to_position, distance, remaining_time)
		remaining_distance = distance
		@current_line = Line.new(@current_position, to_position, distance)

		begin 
			remaining_distance = tick(remaining_distance, remaining_time, distance)
			remaining_time -= 1	
		end while remaining_distance > 0 && remaining_time > -1000
		@speed = 0
	end


	def wait(time)
		time.times do
			@current_speed = 0
			@current_acceleration = 0
			@current_time += 1
			record
		end
	end

	def tick(remaining_distance, remaining_time, distance)
		target_speed = 0

		if remaining_time >= 0.1
			target_speed = remaining_distance / remaining_time
		else
			target_speed = 100000
		end

		# Cap the max speed
		target_speed = speed_function(target_speed)

		# Acceleration in m/s^2
		acceleration = target_speed - @current_speed 

		# Cap the max acceleration
		@current_acceleration = acceleration_function(acceleration)

		# calculate remaining distance
		remaining_distance -= @current_speed

		# Accelerate
		@current_speed += @current_acceleration

		@current_position = @current_line.get_coordinates_at (distance - remaining_distance)

		# Time happens
		@current_time += 1	

		# record speed and acceleration parameters in tape
		record

		remaining_distance
	end


	#m/s^2
	def acceleration_function(acceleration)
		
		# TODO add noise
		if acceleration > 2.3 # more than 2.5 m/s will be really fast!
			acceleration = 2.3
		end
		if acceleration < -3.5
			acceleration = -3.5
		end

		a= @rnd.rand
		b= @rnd.rand

		#puts "#{acceleration} before #{a} #{b}"
		acceleration += (a / 4)
		acceleration *= (0.9 + (b / 5))
		
		if @rnd.rand > 0.5
			acceleration = -(@rnd.rand * 3.5)
		end

		# Never go back
		if (@current_speed + acceleration) < 0 
			acceleration =- @current_speed
		end

		#puts "#{acceleration} after"
		return acceleration
	end

	#m/s
	def speed_function(speed)
		if speed > 36
			speed = 36
		end

		if speed < 0
			speed = 0
		end

		return speed
	end

	def to_kmh(ms) 
		kmh = ms * 3.6
		kmh = (kmh * 100.0).round / 100.0
	end

	def to_g(ms2)
		g = ms2 / 9.8
		g = (g * 100).round / 100.0
	end

	def empty_records
		@records = Hash.new
		@records[:speed] = Array.new
		@records[:acceleration] = Array.new
		@records[:location] = Array.new
		@records[:period] = @current_time
	end

	def record
		# If the period is finished, then send the data
		if @current_time.sec == 0
			if @since_last >= 	59
				post_data @records
			end
			empty_records
			@since_last = 0
		end
		
		


		# Keep track of records.
		@records[:speed][@since_last] = to_kmh(@current_speed)
		@records[:acceleration][@since_last] = to_g(@current_acceleration)
		@records[:location][@since_last] = @current_position
		@since_last += 1
	end

	def post_data(records)
		#byebug
		speed = Calculator.new(@records[:speed])
		acceleration = Calculator.new(@records[:acceleration])

		# /
		post = Hash.new
		post[:serial_no] = @serial_no
		

		# /data
		post[:data] = Array.new 1
		post[:data][0] = Hash.new
		data = post[:data][0]

		#/data/0
		data[:speed] = Hash.new
		data[:acceleration] = Hash.new
		data[:locations] = Hash.new
		data[:period] = @records[:period].strftime("%Y%m%d%H%M%S")

		#/data/0/speed
		data[:speed][:max] = speed.max
		data[:speed][:avg] = speed.avg
		data[:speed][:min] = speed.min
		data[:speed][:p75] = speed.percentile 0.75
		data[:speed][:p25] = speed.percentile 0.25
		
		#/data/0/acceleration
		data[:acceleration][:up] = 0
		data[:acceleration][:down] = 0
		data[:acceleration][:forward] = acceleration.max
		data[:acceleration][:backward] = acceleration.min
		

		#/data/0/locations
		data[:locations] = Array.new
		(0..5).each do |i| 
			loc = @records[:location][i*10]
			coord = Hash.new
			
			coord[:lat] = loc.x
			coord[:long] = loc.y

			data[:locations][i] = coord
		end
		begin
			post_track post.to_json
		rescue => e
			puts "Exception #{e}"
			byebug
		end

		
	end
end

class GoogleMapsRoute
	def initialize(from, to)
		origin = URI::encode(from.to_s)
		destination = URI::encode(to.to_s)
		apikey = URI::encode("AIzaSyAZwWhYZlrvNvZYnZ-hx3egf-DDemQsLGs")
		url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&key=#{apikey}"
		@ret = get_url_json(url)
	end


	def each
		@ret['routes'].each do | route |
			route['legs'].each do | leg |
				leg['steps'].each do |step|
					s_distance = step['distance']['value']
					s_time = step['duration']['value']
					sf_lat = step['end_location']['lat']
					sf_lng = step['end_location']['lng']
					
					destination = CarVector.new(sf_lat.to_f, sf_lng.to_f)
					yield(s_time.to_i, s_distance.to_i, destination)
				end
			end
		end
	end
end



class Driver
	def initialize(vehicle)
		@current_address = vehicle.current_position
		@vehicle = vehicle
	end

	def drive_to(address)
		puts "Driving from #{@current_address} to #{address}"
		route =  GoogleMapsRoute.new(@current_address, address)
		route.each do |duration, distance, destination|
			puts "\tStep #{duration} seconds, #{distance} Meters to location:(#{destination}) "
			@vehicle.drive_to destination, distance, duration
			@current_address = destination
		end
	end
end

###########
## TESTS ##
###########

def test_line
	c1 = CarVector.new(-34.568471, -58.4055046)
	c0 = CarVector.new(-34.5349911, -58.4668743)

	l= Line.new(c0, c1, 10)

	puts "c0: #{c0}"
	puts "c1: #{c1}"
	puts "Distance R: #{l.distance_ratio}"

	puts l.get_coordinates_at(0)
	puts l.get_coordinates_at(5)
	puts l.get_coordinates_at(10)
end

def test_vehicle
	c1 = CarVector.new(-34.6295239, -58.73865799999999)
	c0 = CarVector.new(-34.6350013, -58.5278417)
	v= Vehicle.new("AAAA19", Time.new(2016, 06, 15, 18, 30, 23), c0)
	
	v.drive_to(c1, 19608, 852)
	v.wait 600
end

def test_percentile
	a= [10, 50, 60]
	calc = Calculator.new(a)

	(0..4).each do |i|
		r = i / 4.0
		puts "#{r} -> #{calc.percentile(r)}"
	end

	puts calc.max
	puts calc.min
	puts calc.avg
end

def drive_dario_fleet
	c0 = CarVector.new(-34.573,-58.4801)

	v= Vehicle.new("AAAA0", Time.new(2016, 06, 15, 00, 00, 23), c0)
	d= Driver.new(v)
	d.drive_to "Av. Cordoba 374, CABA"
	d.drive_to "Av Olazábal 4545, CABA"
	d.drive_to "Alsina 775, Quilmes, Buenos Aires"

	v= Vehicle.new("AAAA1", Time.new(2016, 06, 15, 00, 00, 23), c0)
	d= Driver.new(v)
	d.drive_to "Gobernador Valentín Vergara 2718, B1602DEH Florida, Buenos Aires"
	d.drive_to "Félix Mendelsohn 1402, B1742BJD Paso del Rey, Buenos Aires"

	# v= Vehicle.new("AAAA78", Time.new(2016, 06, 15, 00, 00, 23), c0)
	# d= Driver.new(v)
	# d.drive_to "Belgrano 1529, B1828ACM Banfield, Buenos Aires"
	# d.drive_to "Franklin D. Roosevelt 5749,1431BZS CABA"

	# v= Vehicle.new("AAAA93", Time.new(2016, 06, 15, 00, 00, 23), c0)
	# d= Driver.new(v)
	# d.drive_to "Av Pueyrredón 1640,C1118AAT Buenos Aires"
	# d.drive_to "Av. del Libertador 8334,C1429BNQ CABA"

	# v= Vehicle.new("AAAA98", Time.new(2016, 06, 15, 00, 00, 23), c0)
	# d= Driver.new(v)
	# d.drive_to "Av. de los Constituyentes 6020,1431 Buenos Aires"
	# d.drive_to "Av. Federico Lacroze 3490,C1426CQU CABA"
end

class Conurbano
	def initialize
		@area = Geometry::Polygon.new [-58.48717402604624,-34.4878806058396], [-58.54283775668031,-34.44563840594787], 
									  [-58.59217071356932,-34.49347491893651], [-58.57296129864327,-34.52707536486928], 
				  					  [-58.65582428380958,-34.58807555438049], [-58.53874122413309,-34.69742499668709], 
				  					  [-58.46509003010867,-34.73650095021471], [-58.417333862044,-34.77708176337043], 
				  					  [-58.38006945217039,-34.82733132870203], [-58.19030239548302,-34.7663570248184], 
				  					  [-58.23506218266494,-34.72024625218433], [-58.3001053699785,-34.68688466607215], 
				  					  [-58.36392691824155,-34.63265200104309], [-58.36770837492121,-34.60724878377332], 
				  					  [-58.40980148897666,-34.57021280331122], [-58.44193367509822,-34.55450296172231], 
				  					  [-58.46854381042188,-34.5362076906798], [-58.48525193199006,-34.51537144154021], 
				  					  [-58.48717402604624,-34.4878806058396]

	end

	def is_conurbano_location(v)
		ret = (@area <=> Geometry::Point[v.y, v.x]) >= 0
		return ret
	end

	def _pick_random_conurbano_location(v, max_dst)
		if !is_conurbano_location(v)
			puts "#{v} is not in conurbano"
			throw :center_not_conurbano
		end
		
		radius = rand * max_dst
		angle = rand * 2 * Math::PI
		point = CarVector.new(v.x + (radius * Math::cos(angle)), v.y + (radius * Math::sin(angle)))

		if ! is_conurbano_location(point)
			puts "#{point} not in conurbano, recalcul ating with radius #{radius} prev #{max_dst}"
			point = _pick_random_conurbano_location v, radius
		end
		
		return point
	end
	def pick_random_conurbano_location(v, max_dst)
		point = _pick_random_conurbano_location(v, max_dst)
		puts "#{point} success"
		return point
	end
end



def drive_su_taxi_fleet
	c0 = CarVector.new(-34.573,-58.4801)
	con = Conurbano.new
	for i in 1..100 do
		serial_no = "BBBB#{i}"
		c0 = con.pick_random_conurbano_location c0, 0.1
		v= Vehicle.new(serial_no, Time.new(2016, 06, 15, 00, 00, 23), c0)
		d= Driver.new(v)
		
		for j in 1..10 do
			c0 = con.pick_random_conurbano_location c0, 0.1
			d.drive_to c0
		end
	end
	byebug
end

drive_su_taxi_fleet

#con = Conurbano.new
# con.is_conurbano_location(-34.573,-58.4801)
# con.is_conurbano_location(-34.5438296,-58.5402597)
# con.is_conurbano_location(-34.556209, -58.360411)
# con.is_conurbano_location(-34.564715, -58.356832)
# con.is_conurbano_location(-34.874850, -58.309380)
# con.is_conurbano_location(-34.965728, -59.401201)


# pos = [-34.573,-58.4801]

# (0..50).step(1).each do
# 	pos = con.pick_random_conurbano_location(pos[0],pos[1], 0.1)
# end

#drive_dario_fleet

#drive_su_taxi_fleet