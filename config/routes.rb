Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :best
      end
    end
  end
end
