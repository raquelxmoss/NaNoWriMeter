class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]
 has_many :snippets

  def self.from_omniauth(auth)
    where(
      :github_username => auth[:info][:nickname]
      ).first_or_create do |user|
        user.email = auth[:info][:email]
        user.password = Devise.friendly_token[0,20]
        user.last_submit = DateTime.now
    end
  end

  def get_repos
    HTTParty.get("https://api.github.com/users/#{github_username}/repos").map {|repo| repo["name"] }
  end

  def get_diff
    snippets = []
    commits = HTTParty.get(get_url)
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

  def get_url
    if last_submit?
      "https://api.github.com/repos/#{github_username}/#{repo}/commits?since=#{last_submit.to_s.gsub(" ", "%20")}"
    else
      "https://api.github.com/repos/#{github_username}/#{repo}/commits"
    end
  end
end
