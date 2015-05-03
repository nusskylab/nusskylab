class UsersController < ApplicationController
  def index
    if can_view_all_users
      @users = User.all
    else
      does_not_have_access
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(get_user_params)
    flash = {}
    if @user.save
      flash[:success] = 'The user has been successfully created'
      redirect_to users_path, flash: flash
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    if can_view_a_user
      @user = User.find(params[:id])
    else
      does_not_have_access
    end
  end

  def update
    @user = User.find(params[:id])
    flash = {}
    if @user and @user.update(get_user_params)
      flash[:success] = 'The update is successfully saved'
      redirect_to @user, flash: flash
    else
      flash[:danger] = 'The update is not successfully saved'
      redirect_to @user, flash: flash
    end
  end

  def destroy
    @user = User.find(params[:id])
    flash = {}
    if @user.destroy
      flash[:success] = 'The user has been successfully deleted'
    else
      flash[:warning] = 'The deletion is not successful'
    end
    redirect_to users_path, flash: flash
  end

  private
    def get_user_params
      user_param = params.require(:user).permit(:user_name, :email, :uid, :provider)
    end

    def can_view_a_user
      (not session[:user_id].nil? and not params[:id].nil? and session[:user_id].to_i == params[:id].to_i)
    end

    def can_view_all_users
      admin?
    end
end
