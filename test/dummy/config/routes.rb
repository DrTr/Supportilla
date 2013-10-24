Rails.application.routes.draw do

  resources :posts
  root to: "posts#new"

  mount Supportilla::Engine => "/supportilla", as: "supportilla"
end
