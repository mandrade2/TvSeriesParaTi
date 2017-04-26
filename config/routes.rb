Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  get 'news', to: 'pages#news'
  get 'help', to: 'pages#help'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
