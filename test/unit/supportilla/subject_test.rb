require 'test_helper'

module Supportilla
  class SubjectTest < ActiveSupport::TestCase
    def setup
      @subject = supportilla_subjects(:account)  
    end
    
    test "responds to description" do
      assert_respond_to @subject, :description
      assert_respond_to @subject, :tickets
      assert_respond_to @subject, :activity
    end
    
    test "must be valid" do
      assert @subject.valid?
    end
    
    test "with invalid description" do
      @subject.description = ""
      assert !@subject.valid?
      @subject.description = "a" * 50
      assert !@subject.valid?
    end
    
    test "with duplicate description " do
      @subject.description = "Site content"
      assert !@subject.valid?
    end
    
    test "with invalid activity" do
      @subject.activity = ""
      assert !@subject.valid?
    end
    
    test "have tickets" do
      assert_equal @subject.tickets,
        [supportilla_tickets(:oldest), supportilla_tickets(:ticket)]
    end
    
    test "destroy tickets with itself" do
      assert_difference("Ticket.count", -2){ @subject.destroy }
    end
  end
end
