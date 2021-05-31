class AdminLinksController < ApplicationController
    def index
      !authenticate_user(true, true) && return
      @links = AdminLinks.all
    end
  
    def edit
      !authenticate_user(true, true) && return
      @link = AdminLinks.find(params[:id])
      render locals:{
        link: @link
      }
    end
  
    def update
      !authenticate_user(true, true) && return
      puts params
      puts params[:id]
      @link = AdminLinks.find(params[:id])
      @link.url = params[:admin_links][:url]
      success = @link.save!
      if success
        redirect_to admin_links_path, flash: {
          success: 'Success.'
        }
      else
        redirect_to admin_links_path, flash: {
          danger: 'Action failed.'
        }
      end
    end
  end

  private
  def link_params
      params.require(:admin_links).permit(:url)
  end
  