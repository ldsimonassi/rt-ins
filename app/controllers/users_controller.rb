class UsersController < ApplicationController
  include SessionsHelper
  
  def index
    if not logged_in?
      redirect_to login_path
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params.require(:user).permit([:email, :password, :username, :password_confirmation]))
    @created = @user.save
    if @created
      # Redirect to the users home page
      flash[:success] = "Usuario creado con éxito!"
      redirect_to login_path
    else
      render 'new'
    end
  end
end
