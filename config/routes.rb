Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  # homepage
  root 'home#index'

  # oauth handling
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy', :as => :logout
  get '/auth/failure' => 'sessions#failure'
end
