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
			unless current_user.snippets.find_by_body(snippet[:diff])
				current_user.snippets.create(body: snippet[:diff], word_count: snippet[:diff].split.length, 
																		 commit_message: snippet[:message])
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
		commits = HTTParty.get("https://api.github.com/repos/#{current_user.github_username}/#{repo}/commits?since=#{current_user.last_submit.to_s.gsub(" ", "%20")}")
		commits.each do |commit|
			url = commit["html_url"]
			commit_message = commit["commit"]["message"]
		  diff = open("#{url}.diff") { |diff_file| diff_file.read }
			  .split("\n")
			  .select { |line| line.start_with?('+') }
			  .reject { |line| line.start_with?('++') }
			  .map { |line| line.slice(1..-1) }
			  .join("\n")
		  snippets <<  { diff: diff, message: commit_message }
		end
		snippets
	end

end