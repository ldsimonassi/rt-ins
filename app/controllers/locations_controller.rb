class LocationsController < ApplicationController
  include LocationsHelper
  #Dummy mapped vehicle
  #/vehicle/:vehicle_id/locations?since=100
  def by_vehicle
  	vehicle_id = params[:vehicle_id]
  end

  #Dummy mapped user
  #/user/:user_id/locations?since=10
  def by_user
  	user_id = params[:user_id]
  	user = User.find(user_id)

  	ret = get_last_user_vehicles_and_locations user

	 render json: ret
  end
end
