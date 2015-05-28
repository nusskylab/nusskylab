class UsersController < ApplicationController
  layout 'admins'

  def index
    not check_access(true, true) and return
    if can_view_all_users
      @users = User.all
    else
      does_not_have_access
    end
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

  def edit
    not check_access(true, false) and return
    @user = User.find(params[:id])
    render layout: 'general_layout'
  end

  def show
    not check_access(true, false) and return
    @user = User.find(params[:id])
    if can_view_a_user
      render layout: 'general_layout'
    else
      does_not_have_access
    end
  end

  def preview_as
    @user = User.find(params[:id])
    reset_session
    session[:user_id] = @user.id
    current_user
    redirect_to user_path(@user.id)
  end

  def update
    not check_access(true, false) and return
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

  def get_home_link
    @user ? user_path(@user) : '/'
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

    def can_view_a_user
      admin? or (current_user and current_user.id == @user.id)
    end

    def can_view_all_users
      admin?
    end
end
