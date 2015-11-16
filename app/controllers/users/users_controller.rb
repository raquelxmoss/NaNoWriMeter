class Users::UsersController < ApplicationController
	before_action :get_user

	def settings
		@repos = current_user.get_repos
	end

	def update
		if @user.update(user_params)
			user_repos
			flash[:notice] = "Your settings were updated"
			redirect_to user_settings_path
		else
			flash[:notice] = @user.errors.full_messages.join("\n")
			redirect_to :back
		end
	end

	def word_frequency
		@words = current_user.calculate_word_frequency
	end

private

	def get_user
		@user = current_user
	end

	def user_params
		params.require(:user).permit(:email)
	end

	def user_repos
		params[:user][:repos].reject!(&:empty?).map {|r| current_user.repos.find_or_create_by(name: r) }
	end
end