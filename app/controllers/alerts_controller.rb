class AlertsController < ApplicationController
  include AlertsHelper
  protect_from_forgery except: :create

  def create
  	p = params
	serial_no = p['serial_no']
	driver_internal_id = p['driver_internal_id']
	alert_type = p['alert_type']
	additional_data = p['additional_data']
	period = p['period']
	longitude = p['longitude']
	latitude = p['latitude']

	device = TrackingDevice.find_by_serial_no(serial_no)
	driver = Driver.find_by_internal_id(driver_internal_id)
	alert_type = AlertType.find_by_alert_type(alert_type)


	Alert.create({driver: driver, 
				  alert_type: alert_type,
				  tracking_device: device,
				  additional_data: additional_data,
				  period: period,
				  longitude: longitude,
				  latitude: latitude})

	render nothing:true
  end

  def by_user
  	user_id = params[:user_id]
  	user = User.find(user_id)
	
  	ret = get_last_user_alerts(user)

	render json: ret
  end


end
