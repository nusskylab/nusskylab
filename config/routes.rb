Rails.application.routes.draw do
  devise_scope :user do
    match "/users/auth/:provider",
          constraints: { provider: /openid/ },
          to: "users/omniauth_callbacks#passthru",
          as: :user_omniauth_authorize,
          via: [:get, :post]
    match "/users/auth/:action/callback",
          constraints: { action: /openid/ },
          to: "users/omniauth_callbacks",
          as: :user_omniauth_callback,
          via: [:get, :post]
  end
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  # homepage
  resources :users
  root 'home#index'
end
