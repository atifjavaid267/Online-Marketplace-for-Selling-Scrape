Rails.application.routes.draw do
  get 'notification/index'
  get 'notification/show'
  get 'notification/create'
  get 'notification/update'
  get 'notification/destroy'

  get 'users/home'
  get 'users/otp_setting'
  patch 'users/toggle_otp_status'

  # root
  root 'users#show_root'

  resources :messages, only: %i[create show new]
  mount ActionCable.server => '/cable'

  get 'otp/create'
  get '/otp', to: 'sessions#otp'
  # define the route to submit the OTP form
  post '/otp', to: 'sessions#submit_otp', as: :otp_create_path
  resource :two_factor_authentication

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  devise_for :users, controllers:
  {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :bids

  resources :products do
    resources :ads, only: %i[new create]
    member do
      post :toggle_status
    end
    collection do
      get 'show_root' => 'products#show_root'
    end
  end
  resources :addresses
  resources :ads do
    resources :bids, only: %i[new create]
    get 'view_bids', on: :member
    member do
      post :toggle_status
    end
  end
  resources :orders do
    member do
      post :confirm
      post :cancel
    end
  end
  resources :bids do
    resources :orders, only: %i[new create]
  end
end
