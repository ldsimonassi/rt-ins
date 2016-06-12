def to_kmh(ms) 
	kmh = ms * 3.6
	kmh = (kmh * 100.0).round / 100.0
end

def to_g(ms2)
	g = ms2 / 9.8
	g = (g * 100).round / 100.0
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
		@serial_no = serial_no
		@current_speed = 0
		@rnd = Random.new(Time.now.to_i)
		@current_position = starting_position
	end

	# Drive to a given location in this estimated period of time
	def drive_to(position, distance, remaining_time)
		remaining_distance = distance
		@current_line = Line.new(@current_position, position, distance)

		begin 
			remaining_distance = tick(remaining_distance, remaining_time, distance)
			remaining_time -= 1	
		end while remaining_distance > 0 && remaining_time > -1000
		@speed = 0
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

		acceleration = target_speed - @current_speed # Acceleration in m/s^2

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
		record()

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

	def record() 
		# Keep track of records.

		speed= to_kmh(@current_speed)
		g= to_g(@current_acceleration)

		puts "#{@current_time}, #{speed}, #{g}, #{@current_position}"

		# If period closed, send the vehicle data.
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
	v= Vehicle.new("AAA019", 0, c0)
	
	v.drive_to(c1, 19608, 852)

end

test_line
test_vehicle