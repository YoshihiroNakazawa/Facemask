Rails.application.routes.draw do
  get 'relationships/create'

  get 'relationships/destroy'

  resources :topics do
    resources :comments
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :users, only: [:index]
  resources :relationships, only: [:create, :destroy]
  root 'top#index'
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
