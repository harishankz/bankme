Rails.application.routes.draw do
  get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "home#index"
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registration: 'users/registrations'

  }

  resources :users
  resources :accounts
end
