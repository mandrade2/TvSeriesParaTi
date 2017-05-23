Rails.application.routes.draw do
  resources :news
  resources :series do
    resources :chapters
    collection do
      post '/:id', action: 'add_rating'
      post '/:id', action: 'unview'
    end
    member do
      get '/recommend', action: 'recommend_series'
      post '/recommend', action: 'send_recommendation'
    end
  end
  devise_for :users

  root 'series#index'

  # Pages routes
  get 'help', to: 'pages#help'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about'
  get '/invite', to: 'pages#invite'
  post '/invite', to: 'pages#send_invitation_email'

  # Users routes
  get 'users', to: 'users#index'
  get '/:username', to: 'users#profile', as: :profile, constraints: { username: /[^\/]+/ }
  get 'users/search', to: 'users#search'
  patch 'users/upgrade', to: 'users#upgrade'
  delete 'users/destroy', to: 'users#destroy'

  # Child routes
  get '/:username/children', to: 'users#children',
                             as: :children, constraints: { username: /[^\/]+/ }
  get '/:username/children/new', to: 'users#new_child',
                                 as: :children_new, constraints: { username: /[^\/]+/ }
  post '/:username/children/new', to: 'users#create_child',
                                  as: :children_new_path, constraints: { username: /[^\/]+/ }
end
