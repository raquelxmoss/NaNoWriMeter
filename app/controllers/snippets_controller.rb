require 'open-uri'

class SnippetsController < ApplicationController

	before_action :authenticate_user!

	def index
		@snippets = User.find(params[:user_id]).snippets
	end

	def show
		@snippet = Snippet.find(params[:snippet_id])
	end

	def new
	end

	def create
		snippets = get_diff(current_user.repo)
		snippets.each do |snippet|
			unless current_user.snippets.find_by_body(snippet)
				current_user.snippets.create(body: snippet, word_count: snippet.split.length)
				current_user.update(last_submit: DateTime.now)
			end
		end
		redirect_to user_snippets_path(current_user)
	end

	def destroy
		snippet = params.require(:snippet).permit(:id)
		snippet.destroy
		redirect_to user_snippets_path(current_user)
	end

private
	
	def get_diff(repo)
		snippets = []
		commits = HTTParty.get("https://api.github.com/repos/#{current_user.github_username}/#{repo}/commits?since=#{current_user.last_submit.to_s}")
		commits.map{|c|c["html_url"]}.each do |url|
		  diff = open("#{url}.diff") { |diff_file| diff_file.read }
			  .split("\n")
			  .select { |line| line.start_with?('+') }
			  .reject { |line| line.start_with?('++') }
			  .map { |line| line.slice(1..-1) }
			  .join("\n")
		  snippets << diff
		end
		snippets
	end

end