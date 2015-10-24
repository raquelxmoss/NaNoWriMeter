class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in @user
    redirect_to root_path
  end

  def dev_sign_in
    redirect_to controller: :application, action: :index unless Rails.env.development?
    sign_in(User.find_by_email('raquelxmoss@gmail.com'))
    redirect_to :back
  end

end