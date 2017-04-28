Rails.application.routes.draw do
  resources :series
  devise_for :users
  root 'pages#home'
  get 'news', to: 'pages#news'
  get 'help', to: 'pages#help'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about'
  get 'users', to: 'users#index'
  get 'users/search', to: 'users#search'
  post 'users/search', to: 'users#index'
  delete 'users/destroy', to: 'users#destroy'
end
