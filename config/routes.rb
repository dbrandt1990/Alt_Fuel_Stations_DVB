Rails.application.routes.draw do

  root 'sessions#new'

  #Oauth
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  get '/log_out' => 'sessions#destroy', as: 'logout'

  get '/users/:id/settings' => 'users#settings', as: 'settings'
  patch '/users/:id/settings' => 'users#update_settings'

  #scope methods
  get '/users/:id/stations/residential' => "stations#residential"

  #check is stations in zip have changed
  get '/stations/check_for_updates' => 'stations#check_for_updates'
  get '/stations/search' => 'stations#search', as: 'search'

  resources :sessions, only: [:new, :create]
  resources :users, except: [:index] do
    resources :stations, only: [:index, :new, :create]
  end
  resources :stations, only: [:show] do
    resources :notes, only: [:create]
  end

  resources :users_stations, only: [:update]

  #add and remove associations of user to station
  get '/users/:user_id/stations/:id/delete' => 'stations#delete_user', as: 'remove_station'
  get '/users/:user_id/stations/:id' => 'stations#add_user', as: 'add_station'
  
  #make a button like a link and change this route
  get '/notes/:id/delete' => 'notes#destroy', as: 'remove_note' 

end
