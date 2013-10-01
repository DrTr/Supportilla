module Supportilla
  class TicketMailer < ActionMailer::Base
    
    def ticket_created ticket
      @ticket = ticket
      mail(to: ticket.email, 
           subject: "Your ticket \##{ticket.refer} was successfully sent")
    end
  end
end
