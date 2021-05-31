class ApplicationDeadlinesController < ApplicationController
    def index
      !authenticate_user(true, true) && return
      @page_title = t('.page_title')
      @deadlines = ApplicationDeadlines.order(:id)
    end
    
    # find out how to modify the deadlines without backend changes

    def show
      !authenticate_user(true, true) && return
      @deadline = ApplicationDeadlines.find(params[:id])
      # to-do: page title
    end
  
    def edit
      !authenticate_user(true, true) && return
      @deadline = ApplicationDeadlines.find(params[:id])
      # to-do: page title
    end
  
    def update
      !authenticate_user(true, true) && return
      @deadline = ApplicationDeadlines.find(params[:id])
      is_success = @deadline.update(ddl_params)
      redirect_after_actions(is_success, application_deadlines_path,
                             edit_application_deadline_path(@deadline))
    end
  
    private
  
    def ddl_params
        params.require(:application_deadlines).permit(:name,
                                        :submission_deadline)
    end
  
    def redirect_after_actions(is_success, success_path, failure_path)
      if is_success
        #to-do
        msg = "success"
        redirect_to success_path, flash: {
          success: msg
        }
      else
        msg = "failure"
        redirect_to failure_path, flash: {
          danger: msg
        }
      end
    end
  end
  