Rails.application.routes.draw do
  devise_for :users
  resources :entries
  root 'entries#index'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'
end
