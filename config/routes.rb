Rails.application.routes.draw do
  root "static_pages#home"

  get "/faq", to: "static_pages#help"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  namespace :admin do
    resources :categories, only: [:index, :new, :create]
  end
end
