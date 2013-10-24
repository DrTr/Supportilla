require 'test_helper'
module Supportilla
  class TicketsControllerTest < ActionController::TestCase
    def setup
      @ticket = supportilla_tickets(:ticket)
      @unassigned1 = supportilla_tickets(:newer)
      @closed2 = supportilla_tickets(:older)  
      @unassigned2 = supportilla_tickets(:newest)
      @closed1 = supportilla_tickets(:oldest)  
      @other_staff_ticket = supportilla_tickets(:other_staff)   
      @staff = supportilla_staffs(:staff)
      @routes = Supportilla::Engine.routes
    end
    
    test "should route to tickets controller" do
      assert_recognizes({ controller: "supportilla/tickets", action: "new" }, "/")
      assert_routing "tickets/new", 
        { controller: "supportilla/tickets", action: "new" }
      assert_routing "tickets",
        { controller: "supportilla/tickets", action: "index" }
      assert_routing({ path: "tickets", method: :post },
        { controller: "supportilla/tickets", action: "create" })
      assert_routing "tickets/search",
        { controller: "supportilla/tickets", action: "search" }
      assert_routing "tickets/search",
        { controller: "supportilla/tickets", action: "search" }
      assert_routing "tickets/1", 
        { controller: "supportilla/tickets", action: "show", id: "1" }       
      assert_routing "tickets/1/edit", 
        { controller: "supportilla/tickets", action: "edit", id: "1" }
      assert_routing({ path: "tickets/1", method: :put },
        { controller: "supportilla/tickets", action: "update", id: "1" })
      assert_routing({ path: "tickets/1/append", method: :post },
        { controller: "supportilla/tickets", action: "append", id: "1" })
      assert_routing({ path: "tickets/1/hold", method: :post },
        { controller: "supportilla/tickets", action: "hold", id: "1" })
      assert_routing({ path: "tickets/1/unhold", method: :post }, 
        { controller: "supportilla/tickets", action: "unhold", id: "1" })
    end
    
    test "should get new" do
      get :new
      assert_response :success
      assert_template :new
      assert_not_nil assigns(:ticket)
    end
    
    test "should get show" do
      get :show, { id: @ticket.id_hashed }
      assert_response :success
      assert_template :show
      assert_equal assigns(:ticket), @ticket
    end
    
    test "should create ticket with valid params" do
      assert_difference("Ticket.count") do
        get :create, {ticket: {name: "Test", email: "some@mail.com",
          question: "test", subject_id: 1}}
      end
      assert_response :found 
      assert_redirected_to ticket_path(assigns(:ticket))
      assert_not_nil assigns(:ticket)
    end
    
    test "should render new instead create with idvalid params" do
      get :create
      assert_response :success 
      assert_template :new
      assert_not_nil assigns(:ticket)
      assert assigns(:ticket).errors.any?
    end
  
    test "should get append" do
      old_question = @other_staff_ticket.question
      @request.env["HTTP_REFERER"] = ticket_path(@other_staff_ticket)
      get :append, { id: @other_staff_ticket.id_hashed, addition: "Hello" }
      assert_response :found 
      assert_redirected_to ticket_path(@other_staff_ticket)
      assert_not_nil assigns(:ticket)
      assert_not_nil flash[:notice]
      assert_equal assigns(:ticket).question, old_question + " Hello"
      assert_equal assigns(:ticket).status.identify, "hold"
    end

    test "should redirect without authentication" do
      [:index, :update, :search, :edit, :hold, :unhold].each do |action|
        get action, { id: @ticket.id_hashed }
        assert_response :found
        assert_redirected_to signin_path
        assert_not_nil flash[:notice]
        assert_equal session[:return_to], @request.url
      end
    end

    test "should get index without status" do
      get :index, nil, { staff_id: 1 }
      assert_response :success
      assert_template :index
      assert_equal assigns(:description), "New unassigned tickets"
      assert_equal assigns(:tickets), [@unassigned1, @unassigned2]
    end
    
    test "should get index with some status" do
      get :index, { status: "Closed" }, { staff_id: 1 }
      assert_response :success
      assert_template :index
      assert_equal assigns(:description), "Closed tickets"
      assert_equal assigns(:tickets), [@closed1, @closed2]
    end
    
    test "should get search" do
      get :search, { status: "Closed", search: "010912"}, { staff_id: 1 }
      assert_response :success
      assert_template :index
      assert_equal assigns(:description), "Closed tickets with \"010912\""
      assert_equal assigns(:tickets), [@closed2]
    end

    test "should not get access to not your tickets" do
      [:update, :edit, :hold, :unhold].each do |action|
        get action, { id: @other_staff_ticket.id_hashed }, { staff_id: 1 }
        assert_response :forbidden
        assert_nil assigns(:ticket)
      end
    end
  
    test "should get edit without status" do
      get :edit, { id: @ticket.id_hashed }, { staff_id: 1 }
      assert_response :success
      assert_template :edit
      assert_equal assigns(:ticket), @ticket
      assert_equal assigns(:prev_ticket), supportilla_tickets(:same_staff)
      assert_nil assigns(:next_ticket)
    end
    
    test "should get edit with status" do
      get :edit, { id: @ticket.id_hashed, status: "New unassigned" }, 
        { staff_id: 1 }
      assert_response :success
      assert_template :edit
      assert_equal assigns(:ticket), @ticket
      assert_equal assigns(:next_ticket), @unassigned1
      assert_nil assigns(:prev_ticket)
    end
    
    test "should get hold" do
      @request.env["HTTP_REFERER"] = ticket_path(@unassigned1)
      assert_difference("@staff.tickets.count") do
        get :hold, { id: @unassigned1.id_hashed }, { staff_id: 1 }
      end
      assert_response :found
      assert_redirected_to ticket_path(@unassigned1)
      assert_equal assigns(:ticket).status.identify, "hold"
      assert @staff.tickets.include? @unassigned1
      assert_not_nil flash[:notice]
    end
    
    test "should get unhold" do
      @request.env["HTTP_REFERER"] = ticket_path(@ticket)
      assert_difference("@staff.tickets.count", -1) do
        get :unhold, { id: @ticket.id_hashed }, { staff_id: 1 }
      end
      assert_response :found
      assert_redirected_to ticket_path(@ticket)
      assert_equal assigns(:ticket).status.identify, "open"
      assert !(@staff.tickets.include? @ticket)
      assert_not_nil flash[:notice]
    end
          
    test "should get update with valid params" do
      @request.env["HTTP_REFERER"] = ticket_path(@ticket)
      get :update, { id: @ticket.id_hashed, 
         ticket: { status_id: 6, answer: "test"} }, { staff_id: 1 }
      assert_response :found
      assert_redirected_to ticket_path(@ticket)
      assert_not_nil flash[:notice]
      assert_equal assigns(:ticket).status_id, 6
      assert_equal assigns(:ticket).answer, "test"
    end
    
    test "should get update with invalid params" do
      @request.env["HTTP_REFERER"] = ticket_path(@ticket)
      get :update, { id: @ticket.id_hashed, 
         ticket: { status_id: 16, answer: "test"} }, { staff_id: 1 }
      assert_response :found
      assert_redirected_to ticket_path(@ticket)
      assert_not_nil assigns(:ticket)
      assert_not_nil flash[:error]
    end
  end 
end