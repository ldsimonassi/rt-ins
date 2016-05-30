class VehiclesController < ApplicationController
	include SessionsHelper




	def create	
		## {"name"=>"Vento Laburo", "tracking_serial_no"=>"92348092lkfjs", "plate_no"=>"KJO496", 
		## "chasis_no"=>"2420948729f", "engine_no"=>"skdjfsk3", "price_id"=>"951", "commit"=>"Registrar vehículo", 
		## "controller"=>"vehicles", "action"=>"create"}
	    

		#TODO Read parameters and create vehicle
	    if not logged_in?
 	      redirect_to login_path
	    end

		user = current_user
		td = TrackingDevice.find_by_serial_no(params['tracking_serial_no'])

		params['tracking_device_id'] = td.id
		params['user_id'] = user.id

		p = params.permit([:plate_no, :chasis_no, :engine_no, :name, :price_id, :tracking_device_id, :user_id])

		@vehicle = Vehicle.create(p)
		redirect_to users_path
	end

	def new
		arg= Country.find_by_name('Argentina')
		@brands = Brand.where({country:arg})
	end

end