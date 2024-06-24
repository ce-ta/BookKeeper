Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'home#top'

  get 'signup', to: 'users#new'
  post 'login', to: 'users#login'
  get 'logout', to: 'users#logout'
  get 'login', to: 'users#login_form'

  resources :books
  resources :users, only: [:create, :new, :show, :edit, :update, :destroy]
  resources :posts
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
