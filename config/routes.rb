Supportilla::Engine.routes.draw do
  get "about" => "other_pages#about"
  get "signin" => "sessions#new"
  get "signout" => "sessions#destroy"
  resources :tickets
  resources :users, only: [:new, :create, :index, :destroy]
  root to: "tickets#new"
end
