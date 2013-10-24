require_dependency "supportilla/application_controller"

module Supportilla
  class SessionsController < ApplicationController
    
    def new  
    end
    
    def create
      staff = Staff.find_by_username params[:username]
      if staff && staff.authenticate(params[:password])
        sign_in staff
        redirect_back_or  staff.admin ? staffs_path : tickets_path
      else
        flash.now[:error] = 'Invalid email/password combination' 
        render 'new'
      end
    end
    
    def destroy
      sign_out
      redirect_to root_url
    end
    
    private
    def sign_in(staff)
      session[:staff_id] = staff.id 
    end
    
    def sign_out
      session[:staff_id] = nil
    end
  end
end
