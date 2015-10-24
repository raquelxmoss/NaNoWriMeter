Rails.application.routes.draw do
	root 'application#index'
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  resources :users do
  	resources :snippets, only: [:create, :destroy, :index, :show]
  end
end
