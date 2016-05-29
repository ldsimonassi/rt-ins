class VehiclesController < ApplicationController
	def create
	end

	def new
		@vehicle = Vehicle.new
	end
end
