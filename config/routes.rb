Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #signup routes jsut to make the url pretty

  root 'sessions#new'

  #Oauth
  match '/auth/:provider/callback', to: 'sessions#omniauth', via: [:get, :post]

  get '/users/sign_up' => 'users#new', as: 'new_user'
  post '/users/sign_up' => 'users#create'
  get '/users/sign_in' => 'sessions#new', as: 'login_user'
  post '/users/sign_in' => 'sessions#create'
  get '/users/sign_out' => 'sessions#destroy', as: 'logout_user'

  get '/users/:id/settings' => 'users#settings', as: 'settings'
  post '/users/:id/settings' => 'users#update_settings'

  #add and remove associations of user to station
  get '/users/:user_id/stations/:id/delete' => 'stations#delete_user', as: 'remove_station'
  get '/users/:user_id/stations/:id' => 'stations#add_user', as: 'add_station'

  get '/notes/:id/delete' => 'notes#destroy', as: 'remove_note' 

  #check is stations in zip have changed
  get '/stations/check_for_updates' => 'stations#check_for_updates'

  get '/stations/search' => 'stations#search', as: 'search'


  resources :users, only: [:new, :create, :edit, :update, :destroy, :show] do
    resources :stations, only: [:index]
  end
  resources :stations, only: [:show] do
    resources :notes, only: [:create]
  end
end
