class UsersController < ApplicationController

  def index
    if can_view_all_users
    else
      does_not_have_access
    end
  end

  def show
    if can_view_a_user
      if can_view_all_users
        redirect_to users_url
      else
        @user = User.find(params[:id])
      end
    else
      does_not_have_access
    end
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
