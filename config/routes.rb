Rails.application.routes.draw do
  namespace :api do
    resources :users
    resources :tickets
    resources :events
  end
end
