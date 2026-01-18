
Rails.application.routes.draw do
  root 'pages#home'
  resources :articles
  scope :api do
    resources :users
    put 'auth/login', to: 'users#custom_update'
    get 'auth/login', to: 'sessions#new'
    post 'auth/login', to: 'sessions#create'
    delete 'auth/logout', to: 'sessions#destroy'
    get 'auth/register', to: 'registrations#new'
    post 'auth/register', to: 'registrations#create'
    
    scope :articles do
      get '', to: 'articles#index'
      post '', to: 'articles#create'
      post ':slug/favorite', to: 'articles#favorite' 
      delete ':slug/favorite', to: 'articles#unfavorite'
      get 'new', to: 'articles#new'
      get ':slug', to: 'articles#edit'
      patch ':slug', to: 'articles#update'
      delete ':slug', to: 'articles#destroy'
    end

     scope :comment do
      get '', to: 'comments#index'
      post '', to: 'comments#create'
    end
    scope :profiles do
      get ':username', to: 'profiles#show'
      post ':username/follow', to: 'profiles#follow'
      delete ':username/follow', to: 'profiles#unfollow'
    end
  end
end
