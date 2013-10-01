require_dependency "supportilla/application_controller"

module Supportilla
  class TicketsController < ApplicationController
    def new  
      @ticket = Ticket.new
    end
    
    def create
      @ticket = Ticket.create(params[:ticket])
      TicketMailer.ticket_created(@ticket).deliver
      redirect_to @ticket   
    end
    
    def index
    end
  
    def show
      @ticket = Ticket.find_by_id_hashed(params[:id])
    end
  
    def edit
    end
   
    def destroy
    end
  end
end
