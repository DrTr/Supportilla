require 'test_helper'

module Supportilla
  class SubjectsControllerTest < ActionController::TestCase
    def setup
      @routes = Supportilla::Engine.routes
      @subject = Subject.find(1)
    end
    
    test "should route to subjects controller" do
      assert_routing "subjects", 
        { controller: "supportilla/subjects", action: "index" }
      assert_routing({ path: "subjects", method: :post }, 
        { controller: "supportilla/subjects", action: "create" })
      assert_routing "subjects/1/edit", 
        { controller: "supportilla/subjects", action: "edit", id: "1" }
      assert_routing({ path: "subjects/1", method: :put }, 
        { controller: "supportilla/subjects", action: "update", id: "1" })
      assert_routing({ path: "subjects/1", method: :delete }, 
        { controller: "supportilla/subjects", action: "destroy", id: "1" })
    end
        
    test "should redirect without admin authentication" do
      [:index, :create, :edit, :update, :destroy].each do |action|
        get action, { id: 1 }, { staff_id: 1}
        assert_response :found
        assert_redirected_to signin_path
        assert_not_nil flash[:notice]
        assert_equal session[:return_to], @request.url
      end
    end
    
    test "should get index" do
      get :index, nil, { staff_id: 2 }
      assert_response :success
      assert_template :index
      assert_equal assigns(:subjects), Subject.all
      assert_not_nil assigns(:subject) 
    end
    
    test "should get create with valid params" do
      assert_difference("Subject.count") do
        get :create, { subject: { description: "Test", activity: true} },
          { staff_id: 2 }
      end
      assert_response :success
      assert_template :index
      assert Subject.find_by_description("Test")
      assert_not_nil flash[:notice]
    end
    
    test "should get create with invalid params" do
      assert_no_difference("Subject.count") do
        get :create, { subject: { description: "Account", activity: true} },
          { staff_id: 2 }
      end
      assert_response :success
      assert_template :index
      assert_not_nil flash[:error]
      assert assigns(:subject).errors.any?
    end
    
    test "should get edit" do
      get :edit, { id: 1 }, { staff_id: 2 }
      assert_response :success
      assert_template :edit
      assert_equal assigns(:subject), @subject
      assert_equal assigns(:closed_count), 1
    end
    
    test "should get update with valid params" do
      get :update, { id: 1, subject: { description: "test" }}, { staff_id: 2 }
      assert_response :found
      assert_redirected_to subjects_path
      assert_equal Subject.find(1).description, "test"
      assert_not_nil flash[:notice]
    end
    
    test "should get update with invalid params" do
      get :update, { id: 1, subject: { description: "Site content" }},
        { staff_id: 2 }
      assert_response :found
      assert_redirected_to edit_subject_path(@subject)
      assert_equal Subject.find(1).description, "Account"
      assert_not_nil flash[:error]
    end
    
    test "should get destroy" do
      assert_difference("Subject.count", -1) do
        get :destroy, { id: 1 }, { staff_id: 2 }
      end
      assert_response :found
      assert_redirected_to subjects_path
      assert !Subject.all.include?(@subject)
      assert_not_nil flash[:notice]
    end
  end
end