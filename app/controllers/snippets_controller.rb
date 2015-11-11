require 'open-uri'

class SnippetsController < ApplicationController

	before_action :authenticate_user!

	def index
		@snippets = User.find(params[:user_id]).snippets.order('created_at DESC')
	end

	def show
		@snippet = Snippet.find(params[:snippet_id])
	end

	def new
	end

	def create
		snippets = current_user.get_diff
		snippets.each do |snippet|
			unless current_user.snippets.find_by_body(snippet[:diff])
				current_user.snippets.create(body: snippet[:diff], word_count: snippet[:diff].split.length, 
																		 commit_message: snippet[:message])
				current_user.update(last_submit: DateTime.now)
			end
		end
		current_user.update_word_count
		redirect_to user_snippets_path(current_user)
	end

	def destroy
		snippet = params.require(:snippet).permit(:id)
		snippet.destroy
		redirect_to user_snippets_path(current_user)
	end
end