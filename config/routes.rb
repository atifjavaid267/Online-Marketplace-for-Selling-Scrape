Rails.application.routes.draw do
  root 'users#root'
  get 'users/home'
  get 'users/otp_setting'
  patch 'users/toggle_otp_status'

  resources :messages, only: %i[show]
  mount ActionCable.server => '/cable'

  get 'otp/create'
  get '/otp', to: 'sessions#otp'
  post '/otp', to: 'sessions#submit_otp', as: :otp_create_path
  resource :two_factor_authentication

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  devise_for :users, controllers:
  {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  resources :bids, only: %i[new create index]

  resources :products do
    resources :ads, only: %i[new create]
    member do
      post :toggle_archived
    end
    collection do
      get 'root' => 'products#root'
    end
  end

  resources :addresses, except: [:show]

  resources :ads, except: %i[new create] do
    resources :bids, only: %i[new create]
    member do
      get :view_bids
      post :toggle_archived
    end
  end

  resources :bids, except: %i[new create] do
    resources :orders, only: %i[new create]
  end

  resources :orders, except: %i[new create] do
    resources :messages, only: %i[new create]
    member do
      post :confirm
      post :cancel
    end
  end
end
