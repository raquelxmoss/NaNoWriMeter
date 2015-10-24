require 'open-uri'

class Users::SnippetsController < ApplicationController

	before_action :authenticate_user!

	def index
		@snippets = User.find(params[:user_id]).snippets
	end

	def show
		@snippet = Snippet.find(params[:snippet_id])
	end

	def create
		diff = get_diff(current_user.repo)
		current_user.snippets.create(body: diff, word_count: diff.length)
		redirect_to user_snippets_path(current_user)
	end

	def destroy
		snippet = params.require(:snippet).permit(:id)
		snippet.destroy
		redirect_to user_snippets_path(current_user)
	end

private
	
	def get_diff(repo)
		url = "#{repo}/compare/master%40%7B1day%7D...master.diff"
	  diff = open(url) { |diff_file| diff_file.read }
		  .split("\n")
		  .select { |line| line.start_with?('+ ') }
		  .map { |line| line.slice(1..-1) }
		  .join("\n")
	end

end