Rails.application.routes.draw do
  resources :news
  resources :series do
    resources :chapters
    collection do
      post '/:id', action: 'add_rating'
    end
  end
  devise_for :users

  root 'series#index'
  # Pages routes
  get 'help', to: 'pages#help'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about'
  get '/invite', to: 'pages#invite'
  get 'search', to: 'pages#search'
  post 'search', to: 'pages#search'
  post '/invite', to: 'pages#send_invitation_email'

  # Users routes
  get 'users', to: 'users#index'
  get '/:username', to: 'users#user_profile', as: :profile
  get 'users/search', to: 'users#search'
  get 'users/:username', to: 'users#other_user_profile',
                         as: 'other_user_profile'
  patch 'users/upgrade', to: 'users#upgrade'
  delete 'users/destroy', to: 'users#destroy'

  # Child routes
  get '/:username/children', to: 'users#children',
                             as: :children
  get '/:username/children/new', to: 'users#new_child',
                                 as: :children_new
  post '/:username/children/new', to: 'users#create_child',
                                  as: :children_new_path
  delete '/:username/children/destroy', to: 'users#destroy_child',
                                        as: :children_destroy
end
