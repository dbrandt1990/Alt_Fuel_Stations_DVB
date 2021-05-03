Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #signup routes jsut to make the url pretty

  root 'sessions#new'

  #Oauth
  # match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  #?sign up and login routes without devise
  # get '/signup' => 'users#new'
  # post '/signup' => 'users#create'

  # get '/login' => 'sessions#new'
  # post '/login' => 'sessions#create'
  
  # get '/users/sign_out' => 'sessions#destroy'

  get '/users/:id/settings' => 'users#settings', as: 'settings'
  post '/users/:id/settings' => 'users#update_settings'

  #add and remove associations of user to station
  get '/users/:user_id/stations/:id/delete' => 'stations#delete_user', as: 'remove_station'
  get '/users/:user_id/stations/:id' => 'stations#add_user', as: 'add_station'

  get '/notes/:id/delete' => 'notes#destroy'

  #check is stations in zip have changed
  get '/stations/updated' => 'stations#check_for_updates'

  get '/stations/search' => 'stations#search', as: 'search'


  resources :users, only: [:new, :create, :edit, :update, :destroy, :show]do
    resources :stations, only: [:index]
  end
  resources :stations, only: [:show] do
    resources :notes, only: [:create, :destroy]
  end
end
