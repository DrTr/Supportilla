require_dependency "supportilla/application_controller"

module Supportilla
  class StaffsController < ApplicationController
    before_filter :check_access
        
    def new
      @staff = Staff.new
    end
  
    def index
      @staffs = Staff.paginate(page: params[:page], per_page: 20)
      @count = Staff.count
    end
  
    def create
      @staff = Staff.create(params[:staff])
      if @staff.save
        redirect_to staffs_path, notice: "Staff successfully created."  
      else
        render :new
      end
    end
  
    def destroy
      if Staff.find(params[:id]).destroy
        flash.now[:notice] = "Staff successfully deleted."
      else
        flash.now[:error] = "Failed to delete staff,"
      end
      @staffs = Staff.paginate(page: params[:page], per_page: 20)
      @count = Staff.count
      respond_to do |format|
        format.js          
        format.html { render :index }
      end
    end
  end
end
