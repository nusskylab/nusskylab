Rails.application.routes.draw do
  # homepage
  root 'home#index'

  # oauth handling
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy', :as => :logout
  get '/auth/failure' => 'sessions#failure'
end
