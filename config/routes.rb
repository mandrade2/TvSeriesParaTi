Rails.application.routes.draw do
  resources :news
  resources :series
  devise_for :users
  root 'series#index'
  get 'help', to: 'pages#help'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about'
  get 'users', to: 'users#index'
  get 'users/search', to: 'users#search'
  get 'users/:username', to: 'users#other_user_profile',
                         as: 'other_user_profile'
  get '/:username/children', to: 'users#children',
                             as: :children
  get '/:username/children/new', to: 'users#new_child',
                                 as: :children_new
  get '/:username', to: 'users#user_profile', as: :profile
  post 'users/search', to: 'users#index'
  post '/:username/children/new', to: 'users#create_child',
                                  as: :children_new_path
  patch 'users/upgrade', to: 'users#upgrade'
  delete 'users/destroy', to: 'users#destroy'
  delete '/:username/children/destroy', to: 'users#destroy_child',
                                        as: :children_destroy
end
