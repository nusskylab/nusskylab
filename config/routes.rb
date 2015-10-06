Rails.application.routes.draw do
  # homepage
  root 'home#index'

  devise_for :users, path: 'authentication',
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
    # collection do
    #   get 'batch_upload'
    #   post 'batch_create'
    # end
  end
  resources :advisers, only: [:index, :new, :create, :show, :destroy]
  resources :mentors, only: [:index, :new, :create, :show, :destroy]
  resources :admins, only: [:index, :new, :create, :show, :destroy]
  resources :teams do
    resources :submissions, only: [:new, :create, :edit, :update, :show]
    resources :feedbacks, only: [:new, :create, :edit, :update]
  end
  resources :evaluatings, only: [:index, :new, :create, :edit, :update, :destroy] do
    # collection do
    #   get 'batch_upload'
    #   post 'batch_create'
    # end
  end
  resources :milestones do
    resources :teams, only: [:show] do
      resources :peer_evaluations, only: [:new, :create, :edit, :update, :show]
      resources :received_evals, only: [:index]
      resources :received_feedbacks, only: [:index]
    end
    resources :advisers, only: [:show] do
      resources :received_feedbacks, only: [:index]
      resources :peer_evaluations, only: [:new, :create, :edit, :update, :show]
    end
  end
  resources :survey_templates, except: [:destroy] do
  end
end
