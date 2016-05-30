class PricesController < ApplicationController
  protect_from_forgery except: :index
  def index
  	version_id = params.require('version_id')
  	version = Version.find(version_id)
  	@prices = version.prices
  end
end
