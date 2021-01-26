Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth/v1/user'

  root to: 'landing#landing'

  namespace :admin do
    namespace :v1 do
      get 'home', to: 'home#index'
      resources :users
      resources :posts

      patch '/users/:id/turn_admin', to: 'users#turn_admin'
    end
  end
end
