Rails.application.routes.draw do
  root 'pages#home'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'register', to: 'registrations#new'
  post 'register', to: 'registrations#create'
  resources :articles
  resources :comments
  resources :tags
  scope :api do
    post 'auth/login', to: 'authentication#login'
    resources :users, only: [:show, :create]
    put 'user', to: 'users#custom_update'
    get 'user', to: 'users#current'

    post 'articles/:slug/favorite', to: 'articles#favorite'
    delete 'articles/:slug/favorite', to: 'articles#unfavorite'

    resources :articles, param: :slug do
      resources :comments, only: [:index, :create, :destroy]
      get :feed, on: :collection
    end

    scope :profiles do
      get ':username', to: 'profiles#show'
      post ':username/follow', to: 'profiles#follow'
      delete ':username/follow', to: 'profiles#unfollow'
    end
    resources :tags, only: :index
  end
end
