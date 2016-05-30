class ModelsController < ApplicationController
  protect_from_forgery except: :index
  
  def index
  	brand_id = params.require('brand_id')
  	brand = Brand.find(brand_id)
  	@models = brand.models
  end
end
