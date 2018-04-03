Rails.application.routes.draw do
  # forum engine
  mount Thredded::Engine => '/forum'

  # homepage
  root 'home#index'

  devise_for :users, path: 'authentication',
                     path_names: {
                       sign_in: 'login', sign_out: 'logout'
                     }, controllers: {
                       sessions: 'auth/sessions',
                       passwords: 'auth/passwords'
                     }

  # oauth handling
  post '/auth/:provider/callback' => 'sessions#create', as: :nus_openid_callback
  get '/nus/login' => 'sessions#new', :as => :nus_openid_login
  get '/nus/logout' => 'sessions#destroy', :as => :nus_openid_logout
  get '/auth/failure' => 'sessions#failure', :as => :nus_openid_login_failure

  resources :users do
    member do
      post 'preview_as'
      get 'register_as_student'
      post 'register'
      patch 'register'
      get 'register_as_team'
      post 'register_team'
      patch 'register_team'
      post 'confirm_team'
      patch 'confirm_team'
    end
  end
  resources :students
  resources :advisers, only: [:index, :new, :create, :show, :destroy] do
    member do
      get 'general_mailing'
      post 'send_general_mailing'
      patch 'send_general_mailing'
    end
  end
  resources :mentors, only: [:index, :new, :create, :show, :destroy] do
    member do
      get 'general_mailing'
      post 'send_general_mailing'
      patch 'send_general_mailing'
    end
  end
  resources :admins, only: [:index, :new, :create, :show, :destroy] do
    member do
      get 'toggle_registration'
      get 'general_mailing'
      post 'send_general_mailing'
      patch 'send_general_mailing'
    end
  end
  resources :facilitators, only: [:index, :new, :create, :show, :destroy]
  resources :tutors, only: [:index, :new, :create, :show, :destroy]
  resources :teams do
    resources :feedbacks, only: [:new, :create, :edit, :update]
  end
  resources :evaluatings, only: [:index, :new, :create,
                                 :edit, :update, :destroy]
  resources :milestones do
    resources :teams, only: [:show] do
      resources :submissions, only: [:new, :create, :edit, :update, :show]
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
    member do
      get 'preview'
    end
  end
  resources :submissions
  resources :questions, only: [:create, :update, :destroy]
  resources :tags, only: [:index]
  namespace 'public_views' do
    resources :public_projects, only: [:index]
    resources :public_staff, only: [:index]
  end
end
