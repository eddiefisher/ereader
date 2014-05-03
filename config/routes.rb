Rails.application.routes.draw do
  devise_for :users

  resources :import, only: [:index, :create]

  resources :entries, only: [:index, :show] do
    collection do
      get 'channel/:channel_id', controller: 'entries', action: 'index', as: 'channel'
      get 'get_body', action: 'get_body', as: 'get_body'
      get 'flagged', action: 'flagged', as: 'flagged'
      get 'starred', action: 'starred', as: 'starred'
      post "action/:id/:method", action: "action", as: "action"
      post "batch_actions", action: "batch_actions", as: "batch_actions"
    end
  end
  root 'entries#index'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'
end
