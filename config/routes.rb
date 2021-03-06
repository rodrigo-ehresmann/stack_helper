Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  resources :questions

  root to: 'home#index'
  get 'home/index'
  get 'about' => 'home#about', as: :about
end
