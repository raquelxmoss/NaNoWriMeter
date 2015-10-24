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
    end
  end
end
