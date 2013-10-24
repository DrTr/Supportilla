module Supportilla
  class TicketMailer < ActionMailer::Base
    
    def ticket_created ticket
      @ticket = ticket
      mail(to: ticket.email, 
           subject: "Your ticket \##{ticket.refer} sent")
    end
    
    def ticket_changed ticket
      @ticket = ticket
      mail(to: ticket.email, 
           subject: "Your ticket \##{ticket.refer} updated")      
    end
  end
end
