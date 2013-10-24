require 'test_helper'

module Supportilla
  class StatusesControllerTest < ActionController::TestCase
    def setup
      @routes = Supportilla::Engine.routes
    end
    
    test "should route to statuses controller" do
      assert_routing "statuses/new", 
        { controller: "supportilla/statuses", action: "new" }      
      assert_routing "statuses", 
        { controller: "supportilla/statuses", action: "index" }
      assert_routing({ path: "statuses", method: :post }, 
        { controller: "supportilla/statuses", action: "create" })
      assert_routing "statuses/1/edit", 
        { controller: "supportilla/statuses", action: "edit", id: "1" }
      assert_routing({ path: "statuses/1", method: :put }, 
        { controller: "supportilla/statuses", action: "update", id: "1" })
      assert_routing({ path: "statuses/1", method: :delete }, 
        { controller: "supportilla/statuses", action: "destroy", id: "1" })
    end
        
    test "should redirect without admin authentication" do
      [:new, :index, :create, :edit, :update, :destroy].each do |action|
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
      assert_not_nil assigns(:status)
    end
    
    test "should get index" do
      get :index, nil, { staff_id: 2 }
      assert_response :success
      assert_template :index
      assert_equal assigns(:statuses), Status.all
    end
    
    test "should get create with valid params" do
      assert_difference("Status.count") do
        get :create, { status: { description: "Test", role: "On hold",
          identify: "test" } }, { staff_id: 2 }
      end
      assert_response :found
      assert_redirected_to statuses_path
      assert Status.find_by_identify("test")
      assert_not_nil flash[:notice]
    end
    
    test "should get create with invalid params" do
      assert_no_difference("Status.count") do
        get :create, { status: { description: "Test", role: "On hold",
          identify: "hold" } }, { staff_id: 2 }
      end
      assert_response :success
      assert_template :new
      assert !Status.find_by_identify("test")
      assert assigns(:status).errors.any?
    end
    
    test "should get edit" do
      get :edit, { id: 5 }, { staff_id: 2 }
      assert_response :success
      assert_template :edit
      assert_equal assigns(:status), supportilla_statuses(:cancelled)
      assert_equal assigns(:statuses_for_select),
        [supportilla_statuses(:completed), supportilla_statuses(:closed)]
    end
    
    test "should get update with valid params" do
      get :update, { id: 1, status: { description: "Test" }}, { staff_id: 2 }
      assert_response :found
      assert_redirected_to statuses_path
      assert_equal Status.find(1).description, "Test"
      assert_not_nil flash[:notice]
    end
    
    test "should get update with invalid params" do
      get :update, { id: 1, status: { description: "A" * 99 }}, { staff_id: 2 }
      assert_response :found
      assert_redirected_to edit_status_path(Status.find(1))
      assert_equal Status.find(1).description, "Waiting for staff responce"
      assert assigns(:status).errors.any?
    end

    test "should get destroy" do
      assert_difference("Status.count", -1) do
        assert_difference("Status.find(6).tickets.count") do
          get :destroy, { id: 7, status_id: 6 }, { staff_id: 2 }
        end
      end
      assert_response :found
      assert_redirected_to statuses_path
      assert !Status.find_by_id(7)
      assert Status.find(6).tickets.include? supportilla_tickets(:older)
      assert_not_nil flash[:notice]
    end
  end
end