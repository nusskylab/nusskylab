class AdminsController < ApplicationController
  def index
    @admins = Admin.all
  end

  def new
    @admin = Admin.new
    render locals: {
             users: User.all
           }
  end

  def create
    create_user_and_admin
  end

  def use_existing
    create_admin_using_existing_user
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])
    if update_user
      redirect_to admin_path(@admin.id)
    else
      render 'edit'
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    redirect_to admins_path
  end

  private
  def get_user_param
    user_param = params.require(:user).permit(:user_name, :email, :uid, :provider)
  end

  def create_user_and_admin
    # TODO: handle errors here more gracefully
    user_params = create_user_and_admin
    user = User.new(user_params)
    if user.save
      @admin = Admin.new(user_id: user.id)
      if @admin.save
        redirect_to admins_path
      else
        render 'new', locals: {
                 users: User.all
               }
      end
    else
      render 'new', locals: {
                    users: User.all
                  }
    end
  end

  def create_admin_using_existing_user
    # TODO: handle errors here more gracefully
    user = User.find(params[:admin][:user_id])
    if user
      @admin = Admin.new(user_id: user.id)
      if @admin.save
        redirect_to admins_path
      else
        render 'new', locals: {
                      users: User.all
                    }
      end
    else
      render 'new', locals: {
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
