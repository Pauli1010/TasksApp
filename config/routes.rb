Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'account#show'

  get     'login'   => 'sessions#new',      :as => :login
  post    'login'   => 'sessions#create'
  match   'logout'  => 'sessions#destroy',  :as => :logout, via: [:get, :delete]

  resource 'account', only: [:show, :edit, :update], controller: :account do
    member do
      get :edit_password
      post :update_password
    end
  end

  resources :registrations, only: [:new, :create] do
    get :activate, on: :member
  end

  resources :password_resets, except: [:show, :destroy, :index] do
    get :unlock, on: :member
  end

  resources :tasks do
    member do
      patch :change_status
    end
  end

  namespace :admin do
    resources :dictionaries
    resources :dictionary_items
  end
end
