# HomeController: serves home page
class HomeController < ApplicationController
  def index
    @page_title = t('.page_title')
  end
end
