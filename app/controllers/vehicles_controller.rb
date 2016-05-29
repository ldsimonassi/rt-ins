class VehiclesController < ApplicationController
	def create
		# Execute the Vehicle creation.
		
	end

	def new
		puts "!!! VehiclesController!!!"
		@vehicle = Vehicle.new
	end
end
