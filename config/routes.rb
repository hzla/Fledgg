Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'pages#home'

  get '/logout', to: 'pages#logout', as: 'logout'
  get '/auth/linkedin/callback', to: "sessions#create"


  get '/users/settings', to: 'users#settings', as: 'settings'
  get '/setup', to: 'users#onboarding_profile', as: 'onboarding'
  get '/needed_skills', to: 'users#onboarding_skills', as: 'onboarding_skills'
  get '/availability', to: 'users#onboarding_availability', as: 'onboarding_availability'

  resources :users
  post '/users/search', to: 'users#search', as: "search"
  get '/users/:id/result_info', to: 'users#result_info', as: 'user_result_info'
  get '/users/:id/follow', to: 'users#follow', as: 'follow'
  post '/users/:id/rate', to: 'users#rate', as: 'user_rate'

  resources :skills, only: [:create, :destroy]
  resources :needed_skills, only: [:create, :destroy]


  get '/conversations/trashed', to: 'conversations#trashed', as: 'trashed'
  resources :conversations 
  get '/conversations/:id/trash', to: 'conversations#trash', as: 'trash'
  resources :messages
  get '/meetings/check', to: 'meetings#check', as: 'check'
  get '/meetings/:id/join', to: 'meetings#join', as: 'join'
  resources :meetings
  get '/meetings/:id/accept', to: 'meetings#accept', as: 'accept'
  get '/meetings/:id/rate', to: 'meetings#rate', as: 'rate'
  get '/meetings/:id/decline', to: 'meetings#destroy', as: 'decline'

  get '/feedback', to: 'pages#feedback', as: 'feedback'

  resources :statuses 
  get '/statuses/:id/like', to: 'statuses#like', as: 'like'

  resources :comments


  get '/users/fleddg/:id', to: 'users#access'
end
