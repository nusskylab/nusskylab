class HomeController < ApplicationController
  def index
  end

  def get_page_title
    @page_title = @page_title || 'Home | Orbital'
    super
  end
end
