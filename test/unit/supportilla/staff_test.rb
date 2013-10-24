require 'test_helper'

module Supportilla
  class StaffTest < ActiveSupport::TestCase
    def setup
      @staff = Staff.new(username: "test_staff", admin: false, 
        password: "123", password_confirmation: "123")
      @fixture_staff = supportilla_staffs(:staff)
    end
    
    test "responds" do
      assert_respond_to @staff, :username
      assert_respond_to @staff, :password_digest
      assert_respond_to @staff, :admin
      assert_respond_to @staff, :password
      assert_respond_to @staff, :password_confirmation
      assert_respond_to @staff, :authenticate   
      assert_respond_to @staff, :tickets      
    end
    
    test "password_digest must present" do
      assert_not_nil @staff.password_digest
    end
    
    test "must be valid" do
      assert @staff.valid?
    end
    
    test "with invalid username" do
      @staff.username = ""
      assert !@staff.valid?
      @staff.username = "a" * 20
      assert !@staff.valid?
    end
    
    test "username must be unique" do
      @staff.username = "administrator"
      assert !@staff.valid?
    end
    
    test "without admin" do
      @staff.admin = nil
      assert !@staff.valid?
    end
    
    test "without password" do
      @staff.admin = nil
      assert !@staff.valid?
    end
    
    test "without password confirmation" do
      @staff.admin = nil
      assert !@staff.valid?
    end
    
    test "password dont match confirmation" do
      @staff.password_confirmation = "321"
      assert !@staff.valid?
    end
    
    test "authenticate" do
      assert @staff.authenticate("123")
      assert !@staff.authenticate("321")
    end
    
    test "staffs in alphabetic order" do
      assert_equal Staff.all, [supportilla_staffs(:admin), @fixture_staff]
    end
    
    test "have tickets" do
      assert_equal @fixture_staff.tickets.count, 4
      assert_equal @fixture_staff.tickets.first, supportilla_tickets(:oldest)
    end
  end
end
