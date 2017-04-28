Rails.application.routes.draw do
  root "static_pages#home"

  get "/faq", to: "static_pages#help"
end
