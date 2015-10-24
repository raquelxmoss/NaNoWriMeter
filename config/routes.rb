Rails.application.routes.draw do
	root 'application#index'
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  resources :users do
  	resources :snippets
  end

  devise_scope :user do
    post 'dev_sign_in' => 'users/omniauth_callbacks#dev_sign_in'
  end

end
