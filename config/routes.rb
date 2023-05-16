Rails.application.routes.draw do
  get 'notification/index'
  get 'notification/show'
  get 'notification/create'
  get 'notification/update'
  get 'notification/destroy'
  # for gem 'devise-two-factor'
  patch 'users_otp/enable'
  get 'users_otp/disable'

  get 'users_otp/settings'
  patch 'users_otp/toggle'

  # root
  root 'products#show_root'

  resources :messages, only: %i[create show new]
  mount ActionCable.server => '/cable'

  get 'otp/create'
  get '/otp', to: 'sessions#otp'
  # define the route to submit the OTP form
  post '/otp', to: 'sessions#submit_otp', as: :otp_create_path
  resource :two_factor_authentication

  # devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  devise_for :users, controllers:
  {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get '/users/admin/dashboard' => 'users/admin#dashboard', as: 'admin_dashboard'
  get '/users/seller/home' => 'users/seller#home', as: 'seller_home'
  get '/users/buyer/home' => 'users/buyer#home', as: 'buyer_home'
  resources :bids

  resources :products do
    resources :ads, only: %i[new create]
    member do
      post :toggle_published
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
      post :toggle_published
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
