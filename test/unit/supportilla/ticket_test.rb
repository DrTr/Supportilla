require 'test_helper'

module Supportilla
  class TicketTest < ActiveSupport::TestCase
    def setup
      @ticket = supportilla_tickets(:ticket)
      @newer_ticket = supportilla_tickets(:newer)
      @older_ticket = supportilla_tickets(:older)  
      @newest_ticket = supportilla_tickets(:newest)
      @oldest_ticket = supportilla_tickets(:oldest) 
    end
    
    test "responds and associations" do
      assert_respond_to @ticket, :name
      assert_respond_to @ticket, :email
      assert_respond_to @ticket, :subject_id
      assert_respond_to @ticket, :status_id
      assert_respond_to @ticket, :staff_id
      assert_respond_to @ticket, :subject
      assert_respond_to @ticket, :status
      assert_respond_to @ticket, :staff
      assert_respond_to @ticket, :question
      assert_respond_to @ticket, :refer
      assert_respond_to @ticket, :answer
      assert_respond_to @ticket, :id_hashed
    end
    
    test "have valid subject" do
      assert_equal @ticket.subject, supportilla_subjects(:account)
    end
    
    test "have valid status" do
      assert_equal @ticket.status, supportilla_statuses(:hold)
    end 
    
    test "form ticket fuction" do
      ticket = Ticket.new(name: "test", email: "test@email.com", 
        subject: supportilla_subjects(:account), question: "I'm new ticket")
      ticket.send(:form_ticket)
      assert_equal ticket.refer, "aaa-#{Time.now.strftime("%d%m%y")}"  
      assert_equal ticket.id_hashed, Digest::MD5.hexdigest(ticket.refer)
      assert_equal ticket.status, supportilla_statuses(:unassigned)
      ticket.save
      ticket = Ticket.new(name: "test", email: "test@email.com", 
        subject: supportilla_subjects(:account), question: "I'm new ticket")
      ticket.send(:form_ticket)
      assert_equal ticket.refer, "aab-#{Time.now.strftime("%d%m%y")}"  
    end
    
    test  "ticket creation" do
      ticket = Ticket.new(name: "test", email: "test@email.com", 
        subject: supportilla_subjects(:account),
        question: "I'm new ticket", answer: "Ops!")
      assert !ticket.valid?
      ticket.answer = nil
      ticket.staff_id = 1
      assert !ticket.save
      ticket.staff_id = nil
      assert ticket.valid?
      assert_difference("Ticket.count"){ ticket.save }
      assert_not_nil ticket.refer
      assert_not_nil ticket.id_hashed
      assert_equal ticket.status, supportilla_statuses(:unassigned)
    end
      
    test "with invalid name" do
      @ticket.name = ""
      assert !@ticket.valid?
      @ticket.name = "a" * 50
      assert !@ticket.valid?
    end
    
    test "with invalid email" do
      @ticket.email = ""
      assert !@ticket.valid?
      @ticket.email = "wrong"
      assert !@ticket.valid?
      @ticket.email = "a" * 30 + "@mail.com"
      assert !@ticket.valid?
    end
    
    test "without subject" do
      @ticket.subject = nil
      assert !@ticket.valid?
    end
    
    test "without question" do
      @ticket.question = ""
      assert !@ticket.valid?        
    end
    
    test "with invalid refer" do
      @ticket.refer = ""
      assert !@ticket.valid?  
      @ticket.refer = "ticket1"
      assert !@ticket.valid?         
    end
    
    test "without hashed id" do
      @ticket.question = ""
      assert !@ticket.valid?  
    end
    
    test "without status" do
      @ticket.status = nil
      assert !@ticket.valid?
    end           
    
    test "tickets in ASC order" do
      assert_equal Ticket.all.first, @oldest_ticket
      assert_equal Ticket.all.last, @newest_ticket
    end
    
    test "next scope" do
      assert_equal Ticket.next(@ticket).first, @newer_ticket
    end
    
    test "prew scope" do
      assert_equal Ticket.prev(@ticket).last, @older_ticket
    end
    
    test "search scope" do
      assert_equal Ticket.search("%0813%"), [@newer_ticket, @newest_ticket]
      assert_equal Ticket.search("%Name2%"), [@older_ticket]
      assert_equal Ticket.search("%account%"), [@oldest_ticket, @ticket]
    end
    
    test "ticket's history" do
      @older_ticket.update_attributes(answer: "History test")
      ticket = Ticket.find(@older_ticket.id)
      assert_match ticket.status.description, ticket.history
      assert_match ticket.staff.username, ticket.history
      assert_match ticket.question, ticket.history
      assert_match ticket.answer, ticket.history
    end
  end
end