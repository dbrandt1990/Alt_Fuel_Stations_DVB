Rails.application.routes.draw do

  root 'sessions#new'

  #Oauth
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  get '/log_out' => 'sessions#destroy', as: 'logout'

  get '/users/:id/settings' => 'users#settings', as: 'settings'
  post '/users/:id/settings' => 'users#update_settings'

  #scope methods
  get 'users/:id/stations/residential' => "stations#residential"

  #check is stations in zip have changed
  get '/stations/check_for_updates' => 'stations#check_for_updates'
  get '/stations/search' => 'stations#search', as: 'search'

  resources :sessions, only: [:new, :create]
  resources :users, only: [:new, :create, :edit, :update, :destroy, :show] do
    resources :stations, only: [:index, :new, :create]
  end
  resources :stations, only: [:show] do
    resources :notes, only: [:create]
  end

  #add and remove associations of user to station
  get '/users/:user_id/stations/:id/delete' => 'stations#delete_user', as: 'remove_station'
  get '/users/:user_id/stations/:id' => 'stations#add_user', as: 'add_station'

  get '/notes/:id/delete' => 'notes#destroy', as: 'remove_note' 

end
