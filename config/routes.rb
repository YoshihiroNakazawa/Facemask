Rails.application.routes.draw do
  get 'notifications/index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :users, only: [:index, :show], shallow: true do
    resources :topics, except: [:index]
  end
  resources :topics, only: [:show], shallow: true do
    resources :comments, only: [:index, :create, :destroy, :edit, :update]
  end
  resources :relationships, only: [:create, :destroy]
  resources :conversations, only: [:index, :create, :show], shallow: true do
    resources :messages
  end
  root 'top#index'
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
