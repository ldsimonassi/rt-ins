class DriversController < ApplicationController
	include SessionsHelper
  def new
    @driver = Driver.new
  end

  def create
  	attribs = params.require(:driver).permit([:name, :internal_id, :passphrase])
  	attribs[:user] = current_user
  	@driver = Driver.new(attribs)
    @created = @driver.save
    if @created
      flash[:success] = "Conductor creado con éxito!"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def index
  end

  def delete
  end
end
