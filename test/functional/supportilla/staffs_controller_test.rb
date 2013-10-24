require 'test_helper'

module Supportilla
  class StaffsControllerTest < ActionController::TestCase
    def setup
      @routes = Supportilla::Engine.routes
    end
    
    test "should route to tickets controller" do
      assert_routing "staffs", 
        { controller: "supportilla/staffs", action: "index" }
      assert_routing "staffs/new", 
        { controller: "supportilla/staffs", action: "new" }
      assert_routing({ path: "staffs", method: :post }, 
        { controller: "supportilla/staffs", action: "create" })
      assert_routing({ path: "staffs/1", method: :delete }, 
        { controller: "supportilla/staffs", action: "destroy", id: "1" })
    end
    
    test "should redirect without admin authentication" do
      [:new, :index, :create, :destroy].each do |action|
        get action, { id: 1 }, { staff_id: 1}
        assert_response :found
        assert_redirected_to signin_path
        assert_not_nil flash[:notice]
        assert_equal session[:return_to], @request.url
      end
    end
    
    test "should get new" do
      get :new, nil, { staff_id: 2 }
      assert_response :success
      assert_template :new
      assert_not_nil assigns(:staff)
    end
  
    test "should get index" do
      get :index, nil, { staff_id: 2 }
      assert_response :success
      assert_template :index
      assert_equal assigns(:count), 2
      assert_equal assigns(:staffs), 
        [supportilla_staffs(:admin), supportilla_staffs(:staff)]
    end
  
    test "should get create with valid params" do
      assert_difference("Staff.count") do
        get :create, { staff: { username: "tester", password: "qwer", 
          password_confirmation: "qwer", admin: false } }, { staff_id: 2 }
      end
      assert_response :found
      assert_redirected_to staffs_path
      assert Staff.find_by_username("tester")
      assert_not_nil flash[:notice]
    end
  
    test "should get create with invalid params" do
      assert_no_difference("Staff.count") do
        get :create, { staff: { username: "some_staff", password: "qwer", 
          password_confirmation: "rewq", admin: false } }, { staff_id: 2 }
      end
      assert_response :success
      assert_template :new
      assert assigns(:staff).errors.any?
    end  
    
    test "should get destroy" do
      assert_difference("Staff.count", -1) do
        get :destroy, { id: 1 }, { staff_id: 2 }
      end
      assert_response :success
      assert_template :index
      assert !Staff.find_by_id(1)
      assert_equal assigns(:count), 1
      assert_equal assigns(:staffs), [supportilla_staffs(:admin)]
      assert_not_nil flash[:notice]
    end
  end
end

