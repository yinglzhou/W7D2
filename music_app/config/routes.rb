Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :user, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]
end
