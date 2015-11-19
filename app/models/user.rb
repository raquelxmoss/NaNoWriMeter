class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]
 has_many :repos
 accepts_nested_attributes_for :repos

 STOP_WORDS = [
                "the", "and", "of", "i", "a",
                "to", "is", "it", "in", "on"
              ]

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
    HTTParty.get("https://api.github.com/users/#{github_username}/repos").map {|repo| Repo.new(name: repo["name"])}
  end

  def update_word_count
    repos.map {|r| r.snippets.map {|s| s.body.split(" ").length }}.flatten.reduce(:+)
  end
end
