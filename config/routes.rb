Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'home#top'

  # ユーザー関連
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  get 'logout', to: 'sessions#destroy'


  resources :users, only: [:create, :show, :edit, :update] do
    # ユーザーに関連するログインとログアウトのカスタムルート
    collection do
      get 'login', to: 'users#login_form'
      post 'login', to: 'users#login'
      delete 'logout', to: 'users#logout'
    end
  end

  # 書籍関連
  resources :books

  # 投稿関連
  resources :posts
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
