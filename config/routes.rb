Rails.application.routes.draw do
  resources :news
  resources :series do
    resources :chapters do
      member do
        post '/unview', action: 'unview'
        post '/add_rating', action: 'add_rating'
      end
    end
    member do
      get '/recommend', action: 'recommend_series'
      post '/recommend', action: 'send_recommendation'
      post '/comment', action: 'comment'
      delete '/comment', action: 'delete_comment'
      post '/unview', action: 'unview'
      post '/add_rating', action: 'add_rating'
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
  get 'search', to: 'series#search'
  post 'search', to: 'series#search'
  get 'search_chapter', to: 'chapters#search'
  post 'search_chapter', to: 'chapters#search'

  # Users routes
  get 'users', to: 'users#index'
  get '/:username', to: 'users#profile',
                    as: :profile,
                    constraints: { username: %r{[^\/]+} }
  get 'users/search', to: 'users#search'
  patch 'users/upgrade', to: 'users#upgrade'
  delete 'users/destroy', to: 'users#destroy'

  # Child routes
  get '/:username/children', to: 'users#children',
                             as: :children,
                             constraints: { username: %r{[^\/]+} }
  get '/:username/children/new', to: 'users#new_child',
                                 as: :children_new,
                                 constraints: { username: %r{[^\/]+} }
  post '/:username/children/new', to: 'users#create_child',
                                  as: :children_new_path,
                                  constraints: { username: %r{[^\/]+} }
  delete '/:username/children/destroy', to: 'users#destroy_child',
                                        as: :children_destroy,
                                        constraints: { username: %r{[^\/]+} }
end
