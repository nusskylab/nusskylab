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
      post 'confirm_purge_and_open'
      patch 'confirm_purge_and_open'
      post 'confirm_team'
      patch 'confirm_team'
    end
  end

  resources :students do
    get 'new_batch', on: :collection
    post 'create_batch', on: :collection
    member do
      get 'withdraw_invitation'
      get 'submit_proposal'
      get 'remove_proposal'
      post 'confirm_withdraw'
      patch 'confirm_withdraw'
      post 'upload_proposal'
      patch 'upload_proposal'
      post 'confirm_remove_proposal'
      patch 'confirm_remove_proposal'
      get 'do_evaluation'
    end
  end

  resources :advisers, only: [:index, :new, :create, :show, :destroy] do
    get 'new_batch', on: :collection
    post 'create_batch', on: :collection
    member do
      get 'general_mailing'
      post 'send_general_mailing'
      patch 'send_general_mailing'
    end
  end
  resources :mentors, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    get 'new_batch', on: :collection
    post 'create_batch', on: :collection
    member do
      get 'general_mailing'
      post 'send_general_mailing'
      patch 'send_general_mailing'
      post 'accept_team'
      patch 'accept_team'
    end
  end
  resources :mentor_matchings, only: :index
  # get 'applicant_admin/manage_peer_eval/prepare_peer_eval', to: 'applicant_admin#prepare_peer_eval'
  # post 'applicant_admin/manage_peer_eval', to: 'applicant_admin#applicant_eval_matching'
  # patch 'applicant_admin/manage_peer_eval', to: 'applicant_admin#applicant_eval_matching'
  # get 'applicant_admin/show_evaluators/:id', to: 'applicant_admin#show_evaluators'

  resources :admins, only: [:index, :new, :create, :show, :destroy] do
    get 'new_batch', on: :collection
    post 'create_batch', on: :collection
    member do
      get 'toggle_registration'
      get 'toggle_project_level_swap'
      get 'general_mailing'
      post 'send_general_mailing'
      patch 'send_general_mailing'
    end
  end
  resources :facilitators, only: [:index, :new, :create, :show, :destroy] do
    get 'new_batch', on: :collection
    post 'create_batch', on: :collection
  end
  resources :tutors, only: [:index, :new, :create, :show, :destroy] do
    get 'new_batch', on: :collection
    post 'create_batch', on: :collection
  end

  get '/teams/prepare_eval', to: 'teams#prepare_eval'
  get '/teams/:id/delete_evaluator_team_path/:evaluator_email', to: 'teams#delete_evaluator', as: :delete_eval
  patch '/teams/:id/confirm_delete_relation_team_path/:evaluator_email', to: 'teams#confirm_delete_relation', as: :delete_rel
  #todo: change to  on collection
  resources :teams do
    get 'upload_csv'
    post 'update_teams'
    patch 'update_teams'
    get 'upload_csv_eval'
    post 'update_eval'
    patch 'update_eval'
    post 'applicant_eval_matching', on: :collection
    patch 'applicant_eval_matching', on: :collection
    get 'applicant_eval', on: :collection
    get 'applicant_main', on: :collection
    member do
      get 'select'
      get 'show_evaluators'
      get 'edit_evaluators'
      post 'add_evaluators'
      patch 'add_evaluators'
    end
    resources :feedbacks, only: [:new, :create, :edit, :update]
    member do
      get 'match_mentor'
      post 'match_mentor_success'
      post 'accept_mentor'
    end
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

  resources :application_deadlines, only: [:index, :edit, :update]

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
    resources :group_carousel, only: [:index]
    resources :mentor_slides, only: [:index]
  end
end
