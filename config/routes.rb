Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "account#show"

  get     'login'   => 'sessions#new',      :as => :login
  post    'login'   => 'sessions#create'
  match   'logout'  => 'sessions#destroy',  :as => :logout, via: [:get, :delete]

  resource 'account', only: [:show, :edit, :update], controller: :account do
    resources :password_resets, only: [:edit, :update]
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
end
