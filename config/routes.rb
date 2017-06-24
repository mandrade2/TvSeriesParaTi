Rails.application.routes.draw do
  root 'series#index'
  resources :news

  resources :series do
    resources :chapters do
      member do
        post '/unview', action: 'unview'
        post '/add_rating', action: 'add_rating'
      end
    end
    collection do
      get '/new/search', action: 'search_series_on_api'
      post '/new/search', action: 'create_series_from_api'
    end
    member do
      get '/recommend', action: 'recommend_series'
      post '/recommend', action: 'send_recommendation'
      post '/comment', action: 'comment'
      post '/comment/like', action: 'like_comment'
      patch '/comment', action: 'toggle_spoiler'
      delete '/comment', action: 'delete_comment'
      post '/unview', action: 'unview'
      post '/add_rating', action: 'add_rating'
    end
  end

  resources :favorites, only: %i[index create destroy]

  devise_for :users

  resources :users, only: %i[index] do
    collection do
      get 'search'
      patch 'upgrade'
      delete 'destroy', as: :destroy
    end
  end

  # Pages routes
  get 'help', to: 'pages#help'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about'
  get 'myseries', to: 'pages#myseries'

  get '/invite', to: 'pages#invite'
  post '/invite', to: 'pages#send_invitation_email'

  get 'search', to: 'series#search'
  post 'search', to: 'series#search'

  get 'search_chapter', to: 'chapters#search'
  post 'search_chapter', to: 'chapters#search'

  # Users routes
  get '/stats', to: 'users#get_stats'
  get '/:username', to: 'users#profile',
                    as: :profile,
                    constraints: { username: %r{[^\/]+} }

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
