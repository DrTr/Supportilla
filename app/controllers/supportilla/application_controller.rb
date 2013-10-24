module Supportilla
  class ApplicationController < ApplicationController
    include ApplicationHelper
    layout "supportilla"
    
    private  
    def store_location
      session[:return_to] = request.url
    end
    
    def redirect_back_or(default)
      redirect_to(session[:return_to] || default)
      session.delete(:return_to)
    end
    
    def check_access
      unless current_staff && current_staff.admin
        store_location
        redirect_to signin_url, notice: "Please sign in as admin." 
      end
    end
  end
end
