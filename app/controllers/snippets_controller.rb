require 'open-uri'
class SnippetsController < ApplicationController

	before_action :authenticate_user!

	def index
		@snippets = User.find(params[:user_id]).repos.map(&:snippets).flatten
	end

	def show
		@snippet = Snippet.find(params[:snippet_id])
	end

	def new
	end

	def create
		snippets = current_user.repos.each { |r| r.get_diff }
		current_user.repos.each { |r| r.update_word_count }
		current_user.update(last_submit: DateTime.now)
		redirect_to user_snippets_path(current_user)
	end

	def destroy
		snippet = params.require(:snippet).permit(:id)
		snippet.destroy
		redirect_to user_snippets_path(current_user)
	end
end