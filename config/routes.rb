require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'questions#index'

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # mount ActionCable.server => '/cable'

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  namespace :users do
    resources :emails, only: %i[new create]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all_except_me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  resource :search, only: :show
  resolve('Search') { [:search] }

  concern :voted do
    member do
      patch :like
      patch :dislike
      delete :cancel
    end
  end

  concern :commented do
    member do
      post :comment
    end
  end

  resources :questions, concerns: %i[voted commented] do
    resources :subscriptions, only: %i[create destroy], shallow: true
    resources :answers, concerns: %i[voted commented], shallow: true do
      member do
        patch :best
      end
    end
  end
end
