module LocationsHelper

	FICTION_START_TIME = Time.new(2016, 06, 15, 00, 00, 23)
	ACTUAL_START_TIME = Time.new

	def get_current_fiction_time
		current_time = Time.new
		fiction_time = FICTION_START_TIME + (current_time - ACTUAL_START_TIME) * 10
		fiction_time
	end

	def get_current_fiction_time_str
		fiction_time = get_current_fiction_time
		return fiction_time.strftime("%Y%m%d%H%M%S")
	end


	def get_user_vehicles_and_locations(user, day_mask)
	  	ret = Hash.new

	  	user.vehicles.each do |v|
	  		vehicle = Hash.new
	  		ret[v.id] = vehicle
	  		vehicle[:id] = v.id
	  		vehicle[:name] = v.name
			vehicle[:locations] = Array.new
	  		
			# Query locations.
			# Add order by and limit.
			# 2016061500040030
	  		locations = v.tracking_device.device_locations.where('period LIKE ?', "#{day_mask}%").order('period desc')
			
			#TODO add period

			locations.each do |l|
				location = Array.new
				vehicle[:locations] << location
				location[0] = l.latitude
				location[1] = l.longitude
			end
	  	end
	  	ret
	end	

	def get_last_user_vehicles_and_locations(user)
	  	ret = Hash.new

	  	puts "#{get_current_fiction_time.inspect}"
	  	puts "#{get_current_fiction_time_str}"
	  	user.vehicles.each do |v|
	  		vehicle = Hash.new
	  		ret[v.id] = vehicle
	  		vehicle[:id] = v.id
	  		vehicle[:name] = v.name
	  		vehicle[:tracking_serial_no] = v.tracking_device.serial_no
			vehicle[:locations] = Array.new
	  		
			# Query locations.
			# Add order by and limit.
	  		locations = v.tracking_device.device_locations.where("period <  '#{get_current_fiction_time_str}'").order('period desc').limit(50)
			
			if locations.length > 0 
				vehicle[:from] = locations.first.period
				vehicle[:to] = locations.last.period
			end

			locations.each do |l|
				location = Array.new
				vehicle[:locations] << location
				location[0] = l.latitude
				location[1] = l.longitude
			end
	  	end
	  	ret
	end	
end
