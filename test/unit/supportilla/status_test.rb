require 'test_helper'

module Supportilla
  class StatusTest < ActiveSupport::TestCase
    def setup
      @status = supportilla_statuses(:unassigned)  
    end
    
    test "responds to" do
      assert_respond_to @status, :description
      assert_respond_to @status, :tickets
      assert_respond_to @status, :identify
      assert_respond_to @status, :role
      assert_respond_to @status, :basic
    end
    
    test "must be valid" do
      assert @status.valid?
    end
    
    test "with invalid description" do
      @status.description = ""
      assert !@status.valid?
      @status.description = "a" * 31
      assert !@status.valid?
    end
    
    test "without role" do
      @status.role = ""
      assert !@status.valid?
    end
    
    test "with invalid indentify" do
      @status.identify = ""
      assert !@status.valid?
      @status.description = "a" * 31
      assert !@status.valid?
    end
    
    test "without basic" do
      @status.basic = nil
      assert !@status.valid?
    end
    
    test "indentify must be unique" do
       assert !Status.new(role: "In discuss", description: "On staff disscuss",
                         identify: "open").valid?       
    end
    
    test "have tickets" do
      assert_equal @status.tickets, 
       [supportilla_tickets(:newer), supportilla_tickets(:newest)]
    end
  end
end
