require_dependency "supportilla/application_controller"

module Supportilla
  class StatusesController < ApplicationController
    before_filter :check_access
    
    def new
      @status = Status.new
    end
  
    def index
      @statuses = Status.all
    end
  
    def edit
      @status = Status.find(params[:id])
      @statuses_for_select = Supportilla::Status.where(
        "role = ? and identify != ?", @status.role, @status.identify)
    end 
     
    def create
      @status = Status.new(params[:status])
      @status.basic = false
      if @status.save
        redirect_to statuses_path, notice: "Status successfully created."
      else
        render :new
      end
    end
    
    def update
      @status = Status.find(params[:id])
      if @status.update_attributes(description: params[:status][:description])
        flash[:notice] = "Status successfully updated."
        redirect_to statuses_path
      else
        flash[:error] = @status.errors.first || "Failed to update status."
        redirect_to edit_status_path(@status)
      end
    end
  
    def destroy
      status = Status.find(params[:id])
      if status.tickets.any?
        status.tickets.update_all(status_id: params[:status_id])
      end
      if status.destroy
        flash[:notice] = "Status successfully deleted." 
      else
        flash[:notice] = "Failed to delete status."
      end
      redirect_to statuses_path
    end
  end 
end