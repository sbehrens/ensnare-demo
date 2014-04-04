Cookbook::Application.routes.draw do
  get "activities/index"

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  root to: 'recipes#index'

  resources :activities
  resources :users
  resources :sessions
  resources :friendships
  resources :activities
  resources :recipes do
    resources :comments
  end
   mount AppTrap::Engine => "/ensnare", :as => "app_trap_engine"
    match "*_", :to => "app_trap::violations#routing_error"

end
