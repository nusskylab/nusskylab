# Base Class for different roles
class RolesController < ApplicationController
  def index
    !authenticate_user(true, false, additional_users_for_index) && return
    cohort = params[:cohort] || current_cohort
    @page_title = t('.page_title')
    @roles = role_cls.where(cohort: cohort)
    respond_to do |format|
      format.html do
        render locals: {
          all_cohorts: all_cohorts,
          cohort: cohort,
          role_data: data_for_role_index
        }
      end
      format.csv do
        if role_cls && role_cls.respond_to?('to_csv')
          send_data role_cls.to_csv(cohort: cohort)
        else
          render plain: 'Format not supported!'
        end
      end
    end
  end

  def new
    !authenticate_user(true, false, additional_users_for_new) && return
    @page_title = t('.page_title')
    @role = role_cls.new
    cohort = params[:cohort] || current_cohort
    existing_roles = role_cls.where(cohort: cohort)
    occupied_user_ids = existing_roles.map(&:user_id)
    render locals: {
      users: User.where.not(id: occupied_user_ids),
      cohort: cohort,
      role_data: data_for_role_new
    }
  end

  def create
    !authenticate_user(true, false, additional_users_for_new) && return
    post_params = role_params
    user = User.find(post_params[:user_id])
    cohort = post_params[:cohort] || current_cohort
    if user
      @role = role_cls.new(post_params)
      if @role.save
        redirect_to path_for_index(cohort: cohort), flash: {
          success: t('.success_message', user_name: user.user_name)
        }
      else
        redirect_to path_for_new(cohort: cohort), flash: {
          danger: t('.failure_message',
                    error_message: @role.errors.full_messages.join(', '))
        }
      end
    else
      redirect_to path_for_new(cohort: cohort), flash: {
        danger: t('.user_missing_message')
      }
    end
  end

  def show
    @role = role_cls.find(params[:id])
    !authenticate_user(true, false, additional_users_for_show) && return
    @page_title = t('.page_title', user_name: @role.user.user_name)
    render locals: {
      role_data: data_for_role_show
    }
  end

  def edit
    @role = role_cls.find(params[:id])
    !authenticate_user(true, false, additional_users_for_edit) && return
    @page_title = t('.page_title')
    render locals: {
      role_data: data_for_role_edit
    }
  end

  def update
    @role = role_cls.find(params[:id])
    !authenticate_user(true, false, additional_users_for_edit) && return
    cohort = @role.cohort
    if @role.update(role_params)
      redirect_to path_for_index(cohort: cohort), flash: {
        success: t('.success_message', user_name: @role.user.user_name)
      }
    else
      redirect_to path_for_edit(@role.id), flash: {
        danger: t('.failure_message',
                   error_message: @role.errors.full_messages.join(', '))
      }
    end
  end

  def general_mailing
    @role = role_cls.find(params[:id])
    !authenticate_user(true, false, additional_users_for_general_mailing) && return
    mailing_options = general_mailing_params
    receivers = mailing_options[:receivers]
    subject = mailing_options[:subject]
    content = mailing_options[:content]
    if receivers && subject && content
      UserMailer.general_announcement(
        @role.user, User.where(id: receivers), subject, content
      ).deliver_later
      redirect_to path_for_show(@role_id), flash: {
        success: t('.success_message')
      }
    else
      redirect_to path_for_show(@role_id), flash: {
        danger: t('.failure_message')
      }
    end
  end

  def destroy
    !authenticate_user(true, false, additional_users_for_destroy) && return
    @role = role_cls.find(params[:id])
    cohort = @role.cohort
    if @role.destroy && can_destroy_role?
      if handles_for_actions[:destroy] &&
         handles_for_actions[:destroy][:success]
        handle_fn = handles_for_actions[:destroy][:success]
        handle_fn.call
      end
      redirect_to path_for_index(cohort: cohort), flash: {
        success: t('.success_message', user_name: @role.user.user_name)
      }
    else
      redirect_to path_for_index(cohort: cohort), flash: {
        danger: t(
          '.failure_message',
          error_message: @role.errors.full_messages.join(', ')
        )
      }
    end
  end

  # Returns the Model class
  def role_cls
    User
  end

  # Returns params needed for creating/updating role
  def role_params
    {}
  end

  # Returns params needed for sending general emails
  def general_mailing_params
    {}
  end

  # Returns data for role's index
  def data_for_role_index
    {}
  end

  # Returns data for role's new
  def data_for_role_new
    {}
  end

  # Returns data for role's show
  def data_for_role_show
    {}
  end

  # Returns data for role's edit
  def data_for_role_edit
    {}
  end

  # Returns other users who can access index page
  def additional_users_for_index
    []
  end

  # Returns other users who can access new page
  def additional_users_for_new
    []
  end

  # Returns other users who can access edit page
  def additional_users_for_edit
    []
  end

  # Returns other users who can access show page
  def additional_users_for_show
    [@role.user]
  end

  # Returns other users who can send general emails
  def additional_users_for_general_mailing
    []
  end

  # Returns other users who can access destroy action
  def additional_users_for_destroy
    []
  end

  # Returns paths: index for current controller
  def path_for_index(ps = {})
    home_path
  end

  # Returns paths: new for current controller
  def path_for_new(ps = {})
    home_path
  end

  # Returns paths: edit for current controller
  def path_for_edit(role_id)
    home_path
  end

  # Returns paths: show for current controller
  def path_for_show(role_id)
    home_path
  end

  def handles_for_actions
    {}
  end

  def can_destroy_role?
    true
  end
end
