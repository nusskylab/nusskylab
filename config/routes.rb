Rails.application.routes.draw do
  # homepage
  root 'home#index'

  devise_for :users, path: "authentication",
             path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: {
      sessions: 'auth/sessions',
      passwords: 'auth/passwords'
    }

  # oauth handling
  post '/auth/:provider/callback' => 'sessions#create', :as => :nus_openid_callback
  get '/nus/login' => 'sessions#new', :as => :nus_openid_login
  get '/nus/logout' => 'sessions#destroy', :as => :nus_openid_logout
  get '/auth/failure' => 'sessions#failure', :as => :nus_openid_login_failure

  resources :users do
    member do
      post 'preview_as'
    end
  end
  resources :students do
    collection do
      get 'batch_upload'
      post 'batch_create'
      post 'use_existing'
    end
  end
  resources :advisers do
    resources :peer_evaluations
    collection do
      post 'use_existing'
    end
  end
  resources :mentors do
    collection do
      post 'use_existing'
    end
  end
  resources :admins do
    collection do
      post 'use_existing'
    end
  end
  resources :teams do
    resources :submissions, only: [:index, :new, :create, :edit, :update, :show]
    resources :peer_evaluations
  end
  resources :evaluatings, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :milestones do
    resources :teams, only: [:show] do
      resources :received_evals, only: [:index]
    end
  end
end
