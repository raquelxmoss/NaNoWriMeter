class Users::UsersController < ApplicationController
	before_action :get_user

	def settings
		@repos = current_user.repos + current_user.get_repos 
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
		@words = current_user.repos.map {|r| r.calculate_word_frequency }
	end

	def repo_word_counts
		@counts = current_user.repos.map(&:word_count)
	end

private

	def get_user
		@user = current_user
	end

	def user_params
		params.require(:user).permit(:email)
	end

	def user_repos
		current_user.repos.destroy_all
		params[:user][:repos].reject{|r| r == "" }.map {|r| current_user.repos.create(name: r) }
	end
end