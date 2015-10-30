class Users::UsersController < ApplicationController
	before_action :get_user

	def settings
	end

	def update
		if @user.update(user_params)
			flash[:notice] = "Your settings were updated"
		else
	    flash[:notice] = "Sorry, something went wrong!"
		end
		redirect_to user_settings_path
	end

private
	def get_user
		@user = User.find(params[:user_id])
	end

	def user_params
		params.require(:user).permit(:repo)
	end
end