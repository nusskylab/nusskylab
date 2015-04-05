Rails.application.routes.draw do
  # homepage
  root 'home#index'

  # oauth handling
  post '/auth/:provider/callback' => 'sessions#create', :as => :oauth_callback
  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy', :as => :logout
  get '/auth/failure' => 'sessions#failure', :as => :login_failure

  resources :users, :only => [:index, :new, :show]
  resources :students
end
