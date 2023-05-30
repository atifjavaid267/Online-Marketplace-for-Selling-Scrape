Rails.application.routes.draw do
  root 'users#show_root'

  get 'notification/index'
  get 'notification/show'
  get 'notification/create'
  get 'notification/update'
  get 'notification/destroy'

  get 'users/home'
  get 'users/otp_setting'
  patch 'users/toggle_otp_status'

  resources :messages, only: %i[create show new]
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
    registrations: 'users/registrations'
  }

  resources :bids

  resources :products do
    resources :ads, only: %i[new create]
    member do
      post :toggle_archived
    end
    collection do
      get 'show_root' => 'products#show_root'
    end
  end
  resources :addresses

  resources :ads, except: %i[new create] do
    resources :bids, only: %i[new create]
    member do
      get :view_bids
      post :toggle_archived
    end
  end

  resources :bids do
    resources :orders, only: %i[new create]
  end

  resources :orders, except: %i[new create] do
    member do
      post :confirm
      post :cancel
    end
  end
end
