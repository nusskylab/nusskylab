class AdminLinkController < ApplicationController
    def index
      !authenticate_user(true, true) && return
      @links = AdminLink.all
    end
  
    def edit
      !authenticate_user(true, true) && return
      @link = AdminLink.find(params[:id])
      render locals:{
        link: @link
      }
    end
  
    def update
      !authenticate_user(true, true) && return
      @link = AdminLink.find(params[:id])
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
  