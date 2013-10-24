Supportilla::Engine.routes.draw do
  get "signin" => "sessions#new"
  get "signout" => "sessions#destroy"
  match "signin", to: "sessions#create", via: :post
  
  resources :tickets, except: :destroy do
    post :append, :hold, :unhold, on: :member
    get :search, on: :collection
  end
  resources :subjects, except: [:new, :show]
  resources :statuses, except: :show
  resources :staffs, only: [:new, :create, :index, :destroy]
  
  root to: "tickets#new"
end
