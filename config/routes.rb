Rails.application.routes.draw do
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
    root to: 'devise/sessions#new'
  end
  devise_for :users, controllers:
  {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/users/admin/dashboard' => 'users/admin#dashboard', as: 'admin_dashboard'
  get '/users/seller/home' => 'users/seller#home', as: 'seller_home'
  get '/users/buyer/home' => 'users/buyer#home', as: 'buyer_home'
  resources :ads
  get 'display_ads' => 'ads#display_ads', as: 'seller_ads'
  resources :bids

  resources :products
  resources :products do
    resources :ads, only: %i[new create]
  end
  # get '/products/:product_id/ads/new', to:   'ads#new'
  # post '/products/:product_id/ads', to:      'ads#create'
  resources :addresses

  resources :ads do
    resources :bids, only: %i[new create]
    get 'view_bids', on: :member
    # get '/ads/:ad_id/bids/view_bids', to: 'bids#view_bids', as: 'view_bids_ad_bid'

  end
end
