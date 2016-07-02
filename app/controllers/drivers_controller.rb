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
      redirect_to drivers_path
    else
      render 'new'
    end
  end

  def index
    if not logged_in?
      redirect_to login_path
    end
    @user = current_user
    @drivers = @user.drivers
  end

  def destroy
    if not logged_in?
      redirect_to login_path
    end

    current_user.drivers.find(params[:id]).delete

    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Conductor eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end


  def edit
    if not logged_in?
      redirect_to login_path
    end

    @driver = Driver.find_by_id(params[:id])

    if !@driver || @driver.user != current_user
      respond_to do |format|
          format.html { redirect_to drivers_url, notice: 'El conductor no existe' }
          format.json { head :no_content }
        end
    end
  end


  def update
    user = current_user
    
    @driver = Driver.find_by_id(params[:id])

    p = params['driver'].permit([:name, :internal_id, :passphrase])

    respond_to do |format|
      if @driver.update(p)
        format.html { redirect_to drivers_path, notice: 'Vehículo actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver, status: :unprocessable_entity }
      end
    end
  end
end
