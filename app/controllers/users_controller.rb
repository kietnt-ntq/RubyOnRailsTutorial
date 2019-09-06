class UsersController < ApplicationController
  # skip_before_action :require_login, only: [:new, :create]
  def index
    @user = User.all()
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
     @user = User.new user_params
    if @user.save
      log_in @user
      flash.now[:success] = "Wellcome to My App"
      redirect_to @user
    else
      flash.now[:danger] = "Register failed"
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :password, :password_confirmation, :email
  end
end
