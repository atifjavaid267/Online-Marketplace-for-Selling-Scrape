Rails.application.routes.draw do
  # root
  root 'products#show_root'

  resources :messages, only: %i[create index show new]
  mount ActionCable.server => '/cable'

  get 'otp/create'
  get '/otp', to: 'sessions#otp'
  # define the route to submit the OTP form
  post '/otp', to: 'sessions#submit_otp', as: :otp_create_path
  resource :two_factor_authentication
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'

    # # for Two-Factor Authentication(2FA) using gem 'active_model_otp'
    # get '/admin/otp', to: 'users/sessions/otp_authentications#new', as: :admin_otp_page
    # post '/admin/otp', to: 'users/sessions/otp_authentications#create', as: :admin_verify_otp
  end

  devise_for :users, controllers:
  {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
    # for two factor authentication
    # confirmations: 'users/confirmations',
    # passwords: 'users/passwords'
  }

  get '/users/admin/dashboard' => 'users/admin#dashboard', as: 'admin_dashboard'
  get '/users/seller/home' => 'users/seller#home', as: 'seller_home'
  get '/users/buyer/home' => 'users/buyer#home', as: 'buyer_home'
  get 'display_ads' => 'ads#display_ads', as: 'seller_ads'
  resources :bids

  resources :products do
    resources :ads, only: %i[new create]
    member do
      post :publish
      post :unpublish
    end
    collection do
      get 'archives' => 'products#archives'
      get 'show_root' => 'products#show_root'
    end
  end
  resources :addresses
  resources :ads do
    resources :bids, only: %i[new create]
    get 'view_bids', on: :member
    member do
      post :publish
      post :unpublish
    end
    collection do
      get 'archives' => 'ads#archives'
    end
  end
  resources :orders do
    collection do
      get :show_pending
      get :show_successful
      get :show_cancelled
    end
    member do
      post :confirm
      post :cancel
    end
  end
  resources :bids do
    resources :orders, only: %i[new create]
  end
end
