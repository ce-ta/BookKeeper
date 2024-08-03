Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :users

  root 'home#top'

  # 書籍関連
  resources :books

  # 投稿関連
  resources :posts do
    resources :comments, only: [:create, :new, :edit, :destroy]
    resources :favorites, only: [:create, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get 'test/index'
end
