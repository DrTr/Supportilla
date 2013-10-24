require 'test_helper'

module Supportilla
  class TicketMailerTest < ActionMailer::TestCase
    test "ticket created" do
      ticket = supportilla_tickets(:ticket)
      TicketMailer.ticket_created(ticket).deliver
      assert !ActionMailer::Base.deliveries.empty?
      email = ActionMailer::Base.deliveries.last
      assert_equal [ticket.email], email.to
      assert_equal "Your ticket \##{ticket.refer} sent",
        email.subject
    end
    
    test "ticket changed" do
      ticket = supportilla_tickets(:older)
      TicketMailer.ticket_changed(ticket).deliver
      assert !ActionMailer::Base.deliveries.empty?
      email = ActionMailer::Base.deliveries.last
      assert_equal [ticket.email], email.to
      assert_equal "Your ticket \##{ticket.refer} updated",
        email.subject
    end
  end
end
