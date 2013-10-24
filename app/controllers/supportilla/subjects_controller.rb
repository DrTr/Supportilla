require_dependency "supportilla/application_controller"

module Supportilla
  class SubjectsController < ApplicationController
    before_filter :check_access

    def index
      @subjects = Subject.all
      @subject = Subject.new
    end
  
    def create
      @subject = Subject.new(params[:subject])
      if @subject.save
        flash.now[:notice] = "Subject successfully created."
        @subject = Subject.new
      else
        flash.now[:error] = "Failed to create subject."
      end
      @subjects = Subject.all
      respond_to do |format|
        format.js
        format.html{ render :index }
      end      
    end
  
    def edit
      @subject = Subject.find(params[:id])
      @closed_count = @subject.tickets.where(status_id:
         Status.where(role: "Closed")).count
    end

    def update
      @subject = Subject.find(params[:id])
      if @subject.update_attributes(params[:subject])
        flash[:notice] = "Ticket successfully updated."
        redirect_to subjects_path
      else
        flash[:error] = @subject.errors.first || "Failed to update subject."
        redirect_to edit_subject_path(@subject)
      end
    end
  
    def destroy
      if Subject.find(params[:id]).destroy
        flash[:notice] = "Subject successfully deleted." 
      else
        flash[:error] = "Failed to delete subject." 
      end
      redirect_to subjects_path
    end
  end 
end