class AdminsController < ApplicationController
  layout 'admins'

  def index
    not check_access(true, true) and return
    @admins = Admin.all
  end

  def new
    not check_access(true, true) and return
    @admin = Admin.new
    render locals: {
             user: nil,
             users: User.all
           }
  end

  def create
    not check_access(true, true) and return
    create_user_and_admin
  end

  def use_existing
    not check_access(true, true) and return
    create_admin_using_existing_user
  end

  def show
    not check_access(true, true) and return
    @admin = Admin.find(params[:id])
  end

  def edit
    not check_access(true, true) and return
    @admin = Admin.find(params[:id])
  end

  def update
    not check_access(true, true) and return
    @admin = Admin.find(params[:id])
    if update_user
      redirect_to admin_path(@admin.id)
    else
      render 'edit'
    end
  end

  def destroy
    not check_access(true, true) and return
    @admin = Admin.find(params[:id])
    @admin.destroy
    redirect_to admins_path
  end

  def get_home_link
    @admin ? admin_path(@admin) : '/'
  end

  def get_page_title
    @page_title = @page_title || 'Admins | Orbital'
    super
  end

  private
    def get_user_param
      user_param = params.require(:user).permit(:user_name, :email, :uid, :provider)
    end

    def create_user_and_admin
      user_params = get_user_param
      user = User.new(user_params)
      if user.save
        @admin = Admin.new(user_id: user.id)
        if @admin.save
          redirect_to admins_path
        else
          render 'new', locals: {
                   user: user,
                   users: User.all
                 }
        end
      else
        render 'new', locals: {
                      user: user,
                      users: User.all
                    }
      end
    end

    def create_admin_using_existing_user
      user = User.find(params[:admin][:user_id])
      if user
        @admin = Admin.new(user_id: user.id)
        if @admin.save
          redirect_to admins_path
        else
          render 'new', locals: {
                        user: user,
                        users: User.all
                      }
        end
      else
        render 'new', locals: {
                      user: user,
                      users: User.all
                    }
      end
    end

    def update_user
      user = @admin.user
      user_param = get_user_param
      user_param[:uid] = user.uid
      user_param[:provider] = user.provider
      user.update(user_param) ? user : nil
    end
end
