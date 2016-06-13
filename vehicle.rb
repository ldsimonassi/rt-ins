require 'byebug'
require 'json'
require 'typhoeus'


def post_track(body)
	puts "posting #{body}"
	response = Typhoeus.post("localhost:3000/tracks",  headers: {'Content-Type'=> "application/json"}, body: body)
	byebug
	puts "#{response}"
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


class Vector
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
		Vector.new(x, y)
	end

	def minus(v2)
		x = @x-v2.x
		y = @y-v2.y
		Vector.new(x, y)
	end

	def plus(v2)
		x = @x+v2.x
		y = @y+v2.y
		Vector.new(x, y)
	end

	def to_s
		"Vector[x:#{@x} y:#{@y} m:#{@m} h:#{@h}"
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

		post_track post.to_json
	end
end


def test_line
	c1 = Vector.new(-34.568471, -58.4055046)
	c0 = Vector.new(-34.5349911, -58.4668743)

	l= Line.new(c0, c1, 10)

	puts "c0: #{c0}"
	puts "c1: #{c1}"
	puts "Distance R: #{l.distance_ratio}"

	puts l.get_coordinates_at(0)
	puts l.get_coordinates_at(5)
	puts l.get_coordinates_at(10)
end


def test_vehicle
	#c0 = Coord.new(-34.6347509, -58.5280824)
	#c1 = Coord.new(-34.6295233, -58.7400136)
	c1 = Vector.new(-34.6295239, -58.73865799999999)
	c0 = Vector.new(-34.6350013, -58.5278417)
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

#test_percentile

#test_line
test_vehicle