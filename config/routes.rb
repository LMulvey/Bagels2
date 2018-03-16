Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:index]
      resource :user, except: [:index]
    resources :tickets, only: [:index]
      resource :ticket, except: [:index]
    resources :events, only: [:index]
      resource :event, except: [:index]
  end
end
