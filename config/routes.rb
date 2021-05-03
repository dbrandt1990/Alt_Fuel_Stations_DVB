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
  
  get '/users/sign_out' => 'sessions#destroy'

  get '/users/:id/settings' => 'users#settings'
  post '/users/:id/settings' => 'users#update_settings'

  #add and remove associations of user to station
  get '/users/:user_id/stations/:id/delete' => 'stations#delete_user' 
  get '/users/:user_id/stations/:id' => 'stations#add_user'

  get '/notes/:id/delete' => 'notes#destroy'

  #display stations that belong to user
  get '/users/:id/stations' => 'users#users_stations'

  #check is stations in zip have changed
  get '/stations/updated' => 'stations#check_for_updates'


  get '/stations/search_form' => 'stations#search_form'
  get '/stations/search' => 'stations#search'


  resources :users
  resources :stations
  resources :notes
end
