Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  namespace :users do
    resources :emails, only: %i[new create]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all_except_me, on: :collection
      end

      resources :questions, only: %i[index show] do
        resources :answers, only: %i[index show], shallow: true
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

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
    resources :answers, concerns: %i[voted commented], shallow: true do
      member do
        patch :best
      end
    end
  end
end
