Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :transactions, only: [ :create ] do
    collection do
      post :deposit
      post :withdraw
      post :transfer
    end
  end
  resources :wallets do
    collection do
      get :check_balance
    end
  end
  resources :stocks do
    collection do
      post :buy
      post :sell
    end
  end
  resources :users, only: [:create]
  resources :teams, only: [:create]
  resources :sessions, only: [:create]
end
