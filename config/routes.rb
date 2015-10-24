Rails.application.routes.draw do
	root 'application#index'
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  devise_scope :user do
      get '/users/auth/:provider' => 'users/omniauth_callbacks#github'
  end
end
