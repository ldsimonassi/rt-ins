class BrandsController < ApplicationController
  def index
  	#TODO Read the query parameter, read the country parameter
  	#TODO Answer with a filtered list of brands
  	render json: %w[audi bmw]
  end
end
