Rails.application.routes.draw do
  devise_for :users
  resources :entries do
    collection do
      get 'channel/:channel_id', controller: 'entries', action: 'index', as: 'channel'
    end
  end
  root 'entries#index'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'
end
