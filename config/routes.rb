Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :bathing_sites do
    resources :reviews
    resources :favourites, only: [:create]
    resources :reports, only: [:new, :create]
  end
  resources :report_reviews, only: [ :new, :create ]

  resources :favourites, only: [:destroy]

  resources :pages

  resources :users

  resources :reports, only: [:show, :index, :update, :destroy ] do
    member do
      patch 'confirmation', to: 'reports#update_confirmation', as: :confirmation
    end
  end

  get '/report_confirmation_page/:id', to: 'reports#confirmation_page', as: :report_confirmation_page
end
