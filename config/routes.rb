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
  get 'children', to: 'users#children'
  get 'children/new', to: 'users#new_children'
  get '/profile', to: 'users#profile'
  post 'users/search', to: 'users#index'
  post 'children/new', to: 'users#create_children'
  patch 'users/upgrade', to: 'users#upgrade'
  delete 'users/destroy', to: 'users#destroy'
  delete 'children/destroy', to: 'users#destroy_children'
end
