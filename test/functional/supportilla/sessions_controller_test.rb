require 'test_helper'

module Supportilla
  class SessionsControllerTest < ActionController::TestCase   
    def setup
      @routes = Supportilla::Engine.routes
    end
    
    test "should route to sessions controller" do
      assert_routing 'signin',
        { controller: "supportilla/sessions", action: "new" }
      assert_routing({path: 'signin', method: :post }, 
       { controller: "supportilla/sessions", action: "create" })
     assert_routing('signout', 
       { controller: "supportilla/sessions", action: "destroy" })
    end  
    
    test "should get new" do
      get(:new, use_route: "supportilla")
      assert_response :success
      assert_template :new
    end

    test "should create session for staff" do
      staff = Staff.create(username: "tester", password: "qwer",
        password_confirmation: "qwer", admin: false)
      post :create, { username: "tester", password: "qwer" }
      assert_response :found
      assert_redirected_to tickets_path      
      assert_equal session[:staff_id], staff.id
    end

    test "should create session for admin" do
      staff = Staff.create(username: "tester", password: "qwer",
        password_confirmation: "qwer", admin: true)
      post :create, { username: "tester", password: "qwer" }
      assert_response :found
      assert_redirected_to staffs_path
      assert_equal session[:staff_id], staff.id      
    end
        
    test "should not create session for invalid staff" do
      staff = Staff.create(username: "tester", password: "qwer",
        password_confirmation: "qwer", admin: false)
      post :create, { username: "tester", password: "321" }
      assert_response :success
      assert_template :new
      assert_nil session[:staff_id] 
      assert_not_nil flash.now[:error]   
    end
  
    test "should get destroy" do
      get :destroy, nil, { staff_id: 1 }
      assert_redirected_to root_path
      assert_nil session[:staff_id]
    end
  end
end
