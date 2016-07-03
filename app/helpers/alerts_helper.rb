module AlertsHelper
	include TimeHelper
	
	def get_last_user_alerts(user)
	  	ret = Array.new
	  	from = get_past_fiction_time_str(1200)
		to = get_current_fiction_time_str

	  	user.vehicles.each do |v|
			alerts = v.tracking_device.alerts.where("period < '#{to}'").where("period > '#{from}'").order('period desc')

			alerts.each do |a|
				alert = Hash.new
				alert[:vehicle_id] = a.tracking_device.vehicles.first.id
				alert[:vehicle_name] = v.name
				alert[:driver_name] = a.driver.name
				alert[:period] = a.period
				alert[:alert_type] = a.alert_type.alert_type
				alert[:description] = a.alert_type.description
				alert[:latitude] = a.latitude
				alert[:longitude] = a.longitude
				alert[:additional_data] = a.additional_data
				ret << alert
			end
	  	end
	  	ret
	end	

end
