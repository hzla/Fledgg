Rails.application.routes.draw do

  root to: 'pages#home'

  get '/auth/linkedin/callback', to: "sessions#create"

  resources :users
  post '/users/search', to: 'users#search', as: "search"
  get '/users/:id/result_info', to: 'users#result_info', as: 'user_result_info'

  resources :skills, only: [:create, :destroy]
  resources :needed_skills, only: [:create, :destroy]

  resources :conversations 
  get '/conversations/:id/trash', to: 'conversations#trash', as: 'trash'
  resources :messages
end
