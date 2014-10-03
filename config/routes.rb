Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'pages#home'

  get '/terms', to: 'pages#terms', as: 'terms'
  get '/privacy', to: 'pages#privacy', as: 'privacy'

  get '/logout', to: 'pages#logout', as: 'logout'
  get '/auth/linkedin/callback', to: "sessions#create"


  get '/users/settings', to: 'users#settings', as: 'settings'
  get '/setup', to: 'users#onboarding_profile', as: 'onboarding'
  get '/needed_skills', to: 'users#onboarding_skills', as: 'onboarding_skills'
  get '/availability', to: 'users#onboarding_availability', as: 'onboarding_availability'



  get '/users/following', to: 'users#following', as: 'following_users'
  get '/users/linkedin', to: 'users#linkedin', as: 'linkedin_users'
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
  get '/conversations/:id/read', to: 'conversations#read', as: 'read'
  resources :messages
  get '/meetings/check', to: 'meetings#check', as: 'check'
  get '/meetings/:id/join', to: 'meetings#join', as: 'join'
  resources :meetings
  get '/meetings/:id/accept', to: 'meetings#accept', as: 'accept'
  get '/meetings/:id/rate', to: 'meetings#rate', as: 'rate'
  get '/meetings/:id/decline', to: 'meetings#destroy', as: 'decline'

  post '/feedback', to: 'pages#feedback', as: 'feedback'

  resources :statuses 
  get '/statuses/:id/like', to: 'statuses#like', as: 'like'

  resources :comments

end
