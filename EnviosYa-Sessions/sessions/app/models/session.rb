class Session < ApplicationRecord
	  devise :token_authenticatable


	  def self.validate_role(role)
	  	if(role == 'user' || role == 'cadet' || role == 'admin')
	  		return true
	  	else
	  		return false
		end	
	  end

	  def self.validate_user_not_logged(user, role)
	  	user_id = user['id']
	  	all.each do |s|
	  		uid = s['user']['id']
	  		urole = s['role']
	  		if (uid.to_i == user_id.to_i && urole == role)
	  			return false
	  		end
	  	end
	  	return true
	  end

	  def self.get_session_by_token(token)
	  	session = where(authentication_token: token)
	  	return session.first
	  end

	  def self.get_token_by_id_and_role(user_id, role)
	  	sessions = all
	  	sessions.each do |s|
	  		id = s['user']['id']
	  		user_role = s['role']
	  		if (id.to_i == user_id && user_role == role)
	  			return s['authentication_token']
	  		end
	  	end
	  end

	  def self.delete_session(token)
	  	where(authentication_token: token).destroy_all
	  end
end
