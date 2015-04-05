class UsersController < ApplicationController
  def index
    if can_view_all_users
    else
      does_not_have_access
    end
  end

  def new
  end

  def create
    if not params[:user_type].nil? and params[:user_type] == 'student'
      @user = create_student_user
    elsif not params[:user_type].nil? and params[:user_type] == 'mentor'
    elsif not params[:user_type].nil? and params[:user_type] == 'adviser'
    end
    render plain: params.inspect
  end

  private
    def create_student_user
      @matric = params[:user_matricnum]
      @user = User.new(params.require(:user).permit(:user_name, :email))
      @user.uid = 'https://openid.nus.edu.sg/' + @matric
      @user.provider = 'NUS'
      @user.save()
      @student = Student.new(user_id: @user.id)
      @student.save()
      return @user
    end

  def edit
  end

  def show
    if can_view_a_user
      @user = User.find(params[:id])
    else
      does_not_have_access
    end
  end

  def update
  end

  def destroy
  end

  private
    def can_view_a_user
      (not session[:user_id].nil? and not params[:id].nil? and session[:user_id].to_i == params[:id].to_i)
    end

  private
    def can_view_all_users
      if not session[:user_id].nil?
        @admin = Admin.find_by_user_id(session[:user_id])
        not @admin.nil?
      end
    end

  private
    def does_not_have_access
      redirect_to root_url, :alert => 'you are not authorized to view the page'
    end
end
