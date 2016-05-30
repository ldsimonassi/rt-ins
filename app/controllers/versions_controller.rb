class VersionsController < ApplicationController
  protect_from_forgery except: :index
  def index

  	model_id = params.require('model_id')
  	model = Model.find(model_id)
  	@versions = model.versions
  end
end
