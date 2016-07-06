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
		redirect_to vehicles_path
	end

	def new
	    if not logged_in?
 	      redirect_to login_path
	    end
		@brands = Brand.where({country:current_user.country})
	end


	def edit
		if not logged_in?
			redirect_to login_path
		end

		@vehicle = Vehicle.find_by_id(params[:id])

		if !@vehicle || @vehicle.user != current_user
			redirect_to vehicles_path
			respond_to do |format|
		      format.html { redirect_to vehicles_url, notice: 'El vehículo no existe' }
		      format.json { head :no_content }
		    end
		end
		@brands = Brand.where({country:current_user.country})
	end

	def update
		user = current_user
		td = TrackingDevice.find_by_serial_no(params['tracking_serial_no'])
		@vehicle = Vehicle.find_by_id(params[:id])

		if not td 
			flash[:error] = "No se encontró un dispositivo de trackeo con serial_no #{params['tracking_serial_no']}"
			@brands = Brand.where({country:current_user.country})
			render :edit
			return
		end

		params['tracking_device_id'] = td.id
		params['user_id'] = user.id

		p = params.permit([:plate_no, :chasis_no, :engine_no, :name, :price_id, :tracking_device_id, :user_id])

		respond_to do |format|
			if @vehicle.update(p)
				format.html { redirect_to vehicles_path, notice: 'Vehículo actualizado correctamente.' }
				format.json { render :show, status: :ok, location: @vehicle }
			else
				format.html { render :edit }
				format.json { render json: @vehicle, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		if not logged_in?
 	      redirect_to login_path
	    end

	    current_user.vehicles.find(params[:id]).tracking_device.device_locations.destroy_all
	    current_user.vehicles.find(params[:id]).tracking_device.device_tracks.destroy_all
	    current_user.vehicles.find(params[:id]).delete
	    
	    respond_to do |format|
	      format.html { redirect_to vehicles_url, notice: 'Vehículo eliminado exitosamente.' }
	      format.json { head :no_content }
	    end
	end

	def index
		if not logged_in?
			redirect_to login_path
		end
		@user = current_user
		@vehicles = @user.vehicles
	end
end