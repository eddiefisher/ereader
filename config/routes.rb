Rails.application.routes.draw do
  devise_for :users

  resources :import

  resources :entries, only: [:index, :show] do
    collection do
      get 'channel/:channel_id', controller: 'entries', action: 'index', as: 'channel'
      get 'get_body', action: 'get_body', as: 'get_body'
    end
  end
  root 'entries#index'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'
end
