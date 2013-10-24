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
      staff = Staff.find(params[:id]).destroy
      staff.tickets.where(status_id: Status.where(role: "On hold")).update_all(
        status_id: Status.find_by_identify("open"))
      if staff.destroy
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
