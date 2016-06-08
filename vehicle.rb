def to_kmh(ms) 
	kmh = ms * 3.6
	kmh = (kmh * 100.0).round / 100.0
end

def to_g(ms2)
	g = ms2 / 9.8
	g = (g * 100).round / 100.0
end


class Vehicle
	

	#Initialize the vehicle
	def initialize(serial_no, start_date)
		@current_time = start_date
		@serial_no = serial_no
		@current_speed = 0
		@rnd = Random.new(Time.now.to_i)
	end



	# Drive to a given location in this estimated period of time
	def drive_to(distance, remaining_time)
		remaining_distance = distance
		begin 
			remaining_distance = tick(remaining_distance, remaining_time)
			remaining_time -= 1	
		end while remaining_distance > 0 && remaining_time > -1000
		@speed = 0
	end

	def tick(remaining_distance, remaining_time)

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

		# record speed and acceleration parameters in tape
		record()

		# calculate remaining distance
		remaining_distance -= @current_speed

		# Accelerate
		@current_speed += @current_acceleration

		# Time happens
		@current_time += 1	

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
			acceleration = -@current_speed
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

		puts "#{@current_time}, #{speed}, #{g}"

		# If period closed, send the vehicle data.
	end
end


v= Vehicle.new("AAA019", 1000)
v.drive_to(2389, 200)
