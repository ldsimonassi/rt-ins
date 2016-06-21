module VehiclesHelper


	def get_user_vehicles_and_locations(user, day_mask)
	  	ret = Array.new

	  	user.vehicles.each do |v|
	  		vehicle = Hash.new
	  		ret << vehicle
	  		vehicle[:id] = v.id
	  		vehicle[:name] = v.name
			vehicle[:locations] = Array.new
	  		
			# Query locations.
			# Add order by and limit.
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
	  	ret = Array.new

	  	user.vehicles.each do |v|
	  		vehicle = Hash.new
	  		ret << vehicle
	  		vehicle[:id] = v.id
	  		vehicle[:name] = v.name
			vehicle[:locations] = Array.new
	  		
			# Query locations.
			# Add order by and limit.
	  		locations = v.tracking_device.device_locations.order('period desc').limit(30)
			
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

end
