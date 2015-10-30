Rails.application.routes.draw do
	root 'application#index'

  resources :users do
  	resources :snippets
  	get 'settings', to: 'users/users#settings', as: :settings
  	post 'settings', to: 'users/users#update', as: :update_settings
  end

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  devise_scope :user do
    post 'dev_sign_in' => 'users/omniauth_callbacks#dev_sign_in'
  end

end
