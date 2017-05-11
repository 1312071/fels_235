Rails.application.routes.draw do
  root "static_pages#home"
  concern :paginatable do
    get "(page/:page)", action: :index, on: :collection, as: ""
  end
  resources :words, only: :index
  namespace :admin do
    root "dashboard#index"
    resources :users, concerns: :paginatable
    resources :categories
    resources :words
  end
  get "/faq", to: "static_pages#help"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :categories, only: :index
  resources :users, concerns: :paginatable
  resources :relationships, only: [:create, :destroy, :show]
end
