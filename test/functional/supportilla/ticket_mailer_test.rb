require 'test_helper'

module Supportilla
  class TicketMailerTest < ActionMailer::TestCase
    def test_ticket_created
      ticket = supportilla_tickets(:new_ticket)
      email = TicketMailer.ticket_created(ticket).deliver
      assert !ActionMailer::Base.deliveries.empty?
      
      assert_equal [ticket.email], email.to
      assert_equal "Your ticket \##{ticket.refer} was successfully sent",
        email.subject
    end
  end
end
