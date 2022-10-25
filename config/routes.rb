Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "sessions#new"

  get     'login'   => 'sessions#new',      :as => :login
  post    'login'   => 'sessions#create'
  match   'logout'  => 'sessions#destroy',  :as => :logout, via: [:get, :delete]

  get     'account' => 'account#show', :as => :account
  resources :registrations, only: [:new, :create]
  # resources :password_resets, except: [:show, :destroy, :index]
  # resources :tasks
end
