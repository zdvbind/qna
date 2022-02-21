Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

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

  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, shallow: true do
      member do
        patch :best
      end
    end
  end
end
