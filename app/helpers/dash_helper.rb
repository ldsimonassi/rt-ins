module DashHelper
	include TimeHelper

	def get_dashboard_data(user)
	  	ret = Hash.new
	  	from = get_past_fiction_time_str(600)
	  	to = get_current_fiction_time_str


	  	puts "*** from[#{from}]"
		puts "***   to[#{to}]"
	  	user.vehicles.each do |v|
	  		vehicle = Hash.new
	  		ret[v.id] = vehicle

	  		vehicle[:id] = v.id
	  		vehicle[:name] = v.name
	  		vehicle[:tracking_serial_no] = v.tracking_device.serial_no
			vehicle[:locations] = Array.new
			vehicle[:alerts] = Array.new
			vehicle[:tracks] = Array.new
	  		
			the_alerts = v.tracking_device.alerts.where("period < '#{to}'").where("period > '#{from}'").order('period desc')
	  		the_locations = v.tracking_device.device_locations.where("period < '#{to}'").where("period > '#{from}'").order('period desc')
	  		the_tracks = v.tracking_device.device_tracks.where("period < '#{to}'").where("period > '#{from}'").order('period desc').limit(1)

			the_alerts.each do |a|
				alert = Hash.new
				alert[:period] = a.period
				alert[:latitude] = a.latitude
				alert[:longitude] = a.longitude
				alert[:alert_type] = a.alert_type.alert_type
				alert[:description] = a.alert_type.description
				alert[:additional_data] = a.additional_data
				vehicle[:alerts] << alert
			end

			the_locations.each do |l|
				location = Array.new
				vehicle[:locations] << location
				location[0] = l.latitude
				location[1] = l.longitude
			end

			t = the_tracks.first
			if t
				vehicle[:driver_name] = t.driver.name
				vehicle[:speed_max] = t.speed_max
				vehicle[:speed_avg] = t.speed_avg
				vehicle[:acceleration_forward] = t.acceleration_forward
				vehicle[:acceleration_backward] = t.acceleration_backward
				vehicle[:acceleration_up] = t.acceleration_up
				vehicle[:acceleration_down] = t.acceleration_down
			end
	  	end
	  	ret
	end	

end
