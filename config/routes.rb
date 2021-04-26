Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #signup routes jsut to make the url pretty

  root 'sessions#new'

  get '/signup' => 'users#new'
  post '/signup' => 'users#create'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'


  get '/logout' => 'sessions#destroy'

  resources :users
  resources :stations
  resources :notes
end
