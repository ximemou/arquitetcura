class User < ActiveRecord::Base
  	devise :omniauthable, :omniauth_providers => [:facebook]
  	has_many :authorizations
	validates :name, :email, :presence => true
	def self.exits_user_by_email(user_email)
    user=find_by_email(user_email)
    return user
  end
  
  def self.getUserById(user_id)
    return find(user_id)
  end
end
