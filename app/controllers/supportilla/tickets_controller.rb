require_dependency "supportilla/application_controller"

module Supportilla
  class TicketsController < ApplicationController
    before_filter :check_access, except: [:new, :create, :show, :append]    
    before_filter :check_owner, only: [:edit, :update, :hold, :unhold]
        
    def new  
      @ticket = Ticket.new
    end
    
    def create    
      @ticket = Ticket.new(params[:ticket])
      if @ticket.save
        if TicketMailer.default_url_options[:host]
          TicketMailer.ticket_created(@ticket).deliver  
        end
        redirect_to @ticket   
      else
        render :new
      end
    end
    
    def append
      @ticket = Ticket.find_by_id_hashed(params[:id])
      @ticket.question += " #{params[:addition]}"
      @ticket.status = Status.find_by_identify("hold")
      do_update{ @ticket.save }
    end
    
    def index
      params[:status] ||= "New unassigned"
      @tickets = select_collection.paginate(page: params[:page], per_page: 10)
      @description += " tickets"       
    end
    
    def search
      search = "%#{params[:search]}%"
      @tickets = select_collection.search(search).paginate(page: params[:page],
        per_page: 10)
      @description += " tickets with \"#{params[:search]}\""    
      render "index"
    end
  
    def show
      @ticket = Ticket.find_by_id_hashed(params[:id])
    end
  
    def edit
      @ticket = Ticket.find_by_id_hashed(params[:id])
      params[:status] ||= @ticket.status.role
      @next_ticket = select_collection.next(@ticket).first
      @prev_ticket = select_collection.prev(@ticket).last
    end
    
    def update
      @ticket = Ticket.find_by_id_hashed(params[:id])
      do_update{ @ticket.update_attributes(params[:ticket]) }
    end
    
    def hold
      @ticket = Ticket.find_by_id_hashed(params[:id])
      @ticket.staff = current_staff
      @ticket.status = Status.find_by_identify("hold")
      if @ticket.save
        flash[:notice] = "Ticket successfully owned."
      else
        flash[:error] = "Failed to own ticket."
      end
      redirect_to :back
    end
    
    def unhold
      @ticket = Ticket.find_by_id_hashed(params[:id])
      @ticket.staff = nil
      @ticket.status = Status.find_by_identify("open")
      if @ticket.save
        flash[:notice] = "Ticket successfully leaved."
      else
        flash[:error] = "Failed to leave ticket."
      end
      redirect_to :back
    end
    
    private
    def check_access
      unless current_staff
        store_location
        redirect_to signin_url, notice: "Please sign in." 
      end
    end
    
    def check_owner
      ticket = Ticket.find_by_id_hashed(params[:id])
      if ticket.staff && ticket.staff != current_staff
        render text: "403 Forbidden", status: :forbidden
      end
    end
    
    def select_collection
      @description = params[:status]
      if params[:status] == "New unassigned" or params[:status] == "Open"
        Ticket.where(status_id: Status.where(role: params[:status]))
      else
        current_staff.tickets.where(
          status_id: Status.where(role: params[:status]))
      end
    end
    
    def do_update(&block)
      if yield 
        flash[:notice] = "Ticket successfully updated."
        if TicketMailer.default_url_options[:host]
          TicketMailer.ticket_changed(@ticket).deliver 
        end
      else
        flash[:error] = "Failed to update ticket."
      end
      redirect_to :back
    end
  end
end
