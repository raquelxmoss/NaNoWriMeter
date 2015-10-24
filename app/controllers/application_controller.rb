class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

  # def get_files
  #   response = HTTParty.get("#{Rails.application.secrets.github_endpoint}/#{current_user.github_username}/#{current_user.repo_name}/contents")
  #   response.each { |file| get_file_contents(file) }
  # end

  # def get_file_contents(file)
  #   file = current_user.files.find_or_create_by(name: file["name"])
  #   contents = HTTParty.get("#{Rails.application.secrets.github_endpoint}/#{current_user.github_username}/#{current_user.repo_name}/contents/#{file["name"]}",
  #     headers: {"Accept": "application/vnd.github-blob.raw"})
  #   file.update(content: contents)
  # end

  # def parse_contents
  # end
end
