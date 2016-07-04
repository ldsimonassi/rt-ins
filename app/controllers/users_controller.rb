class UsersController < ApplicationController
  include SessionsHelper
  include DashHelper

  
  def dashboard
    if not logged_in?
      redirect_to login_path
    end
    @user = current_user
    @vehicles = @user.vehicles
  end
  
  def new
    @countries = Country.all
    @user = User.new
  end
  
  def create
    @user = User.new(params.require(:user).permit([:email, :password, :username, :first_name, :last_name, :password_confirmation, :country_id]))
    @created = @user.save
    if @created
      flash[:success] = "Usuario creado con éxito!"
      redirect_to login_path
    else
      render 'new'
    end
  end


  def dash_data
    user_id = params[:user_id]
    user = User.find(user_id)

    ret = get_dashboard_data user

    render json: ret
  end
end
