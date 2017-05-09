Rails.application.routes.draw do
  root "static_pages#home"
  concern :paginatable do
    get "(page/:page)", action: :index, on: :collection, as: ""
  end
  resources :users, concerns: :paginatable
  resources :words, only: :index
  get "/faq", to: "static_pages#help"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  namespace :admin do
    resources :categories
  end
end
