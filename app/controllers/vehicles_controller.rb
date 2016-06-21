class VehiclesController < ApplicationController
	include SessionsHelper




	def create	
	    if not logged_in?
 	      redirect_to login_path
	    end

		user = current_user
		td = TrackingDevice.find_by_serial_no(params['tracking_serial_no'])

		if not td 
			flash[:error] = "No se encontró un dispositivo de trackeo con serial_no #{params['tracking_serial_no']}"
			@brands = Brand.where({country:current_user.country})
			render :new
			return
		end
		params['tracking_device_id'] = td.id
		params['user_id'] = user.id

		p = params.permit([:plate_no, :chasis_no, :engine_no, :name, :price_id, :tracking_device_id, :user_id])

		@vehicle = Vehicle.create(p)
		redirect_to users_path
	end

	def new
	    if not logged_in?
 	      redirect_to login_path
	    end
		@brands = Brand.where({country:current_user.country})
	end

end