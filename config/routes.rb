Rails.application.routes.draw do
  # homepage
  root 'home#index'

  # oauth handling
  post '/auth/:provider/callback' => 'sessions#create', :as => :oauth_callback
  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy', :as => :logout
  get '/auth/failure' => 'sessions#failure', :as => :login_failure

  resources :users
  resources :students
  resources :advisers
  resources :mentors
  resources :admins do
    collection do
      post 'use_existing'
    end
  end
  resources :teams do
    resources :submissions
    resources :peer_evaluations
  end
  resources :evaluatings
  resources :milestones
end
