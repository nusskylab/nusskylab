class UsersController < ApplicationController
  layout 'admins'

  def index
    not check_access(true, true) and return
    @users = User.order(:user_name).all
  end

  def new
    not check_access(true, true) and return
    @user = User.new
  end

  def create
    not check_access(true, true) and return
    @user = User.new(get_user_params)
    flash = {}
    if @user.save
      flash[:success] = 'The user has been successfully created'
      redirect_to users_path, flash: flash
    end
  end

  def show
    @user = User.find(params[:id])
    not check_access(true, false, lambda {
                       return current_user.id == @user.id
                         }) and return
    render layout: 'general_layout'
  end

  def preview_as
    not check_access(true, true) and return
    sign_out(current_user)
    user = User.find(params[:id])
    sign_in(user)
    redirect_to user_path(user.id)
  end

  def edit
    @user = User.find(params[:id])
    not check_access(true, false, lambda {
                       return current_user.id == @user.id
                         }) and return
    render layout: 'general_layout'
  end

  def update
    @user = User.find(params[:id])
    not check_access(true, false, lambda {
                       return current_user.id == @user.id
                         }) and return
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
    not check_access(true, true) and return
    @user = User.find(params[:id])
    flash = {}
    if @user.destroy
      flash[:success] = 'The user has been successfully deleted'
    else
      flash[:warning] = 'The deletion is not successful'
    end
    redirect_to users_path, flash: flash
  end

  def get_page_title
    @page_title = @page_title || 'Users | Orbital'
    super
  end

  def user_student?
    student ||= Student.student?(@user.id) if @user
  end

  def user_adviser?
    adviser ||= Adviser.adviser?(@user.id) if @user
  end

  def user_mentor?
    mentor ||= Mentor.mentor?(@user.id) if @user
  end

  def user_admin?
    admin ||= Admin.admin?(@user.id) if @user
  end

  helper_method 'user_student?'
  helper_method 'user_adviser?'
  helper_method 'user_mentor?'
  helper_method 'user_admin?'

  private
    def get_user_params
      user_param = params.require(:user).permit(:user_name, :email, :uid, :provider)
      generated_password = Devise.friendly_token.first(8)
      user_param[:password] = generated_password
      user_param
    end
end
