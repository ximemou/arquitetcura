module AdminsHelper
	def self.save_admin_session(admin)
      response = RestClient.post "#{ENV['SESSIONS_URL']}sessions?role=admin",
        {"user" => admin}.to_json,
        {accept: 'application/json',
        content_type: :json}
    end

	def self.get_admin_token(logged_user, role)
		response= RestClient::Request.new(
	        :method => :get,
	        :url => "#{ENV['SESSIONS_URL']}sessions/token?user_id=#{logged_user}&role=#{role}",
	        :headers =>  {:accept => 'application/json', :content_type => :json}
	    ).execute
	    user_token = response.to_str
	    return user_token
	end	

    def self.delete_session(id)
		token = get_admin_token(id, 'admin')
		response= RestClient::Request.new(
	        :method => :delete,
	        :url => "#{ENV['SESSIONS_URL']}sessions",
	        :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
	    ).execute
	end

	 def self.validate_user(token, user_role)
      response= RestClient::Request.new(
          :method => :get,
          :url => "#{ENV['SESSIONS_URL']}sessions",
          :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
      ).execute
      if response.to_str != 'null'
      session = JSON.parse(response.to_str)
    if(session && session['role']== user_role)
      return session['user']
    else
      return session
    end
else
	return nil
end
  end

  def self.confirmCadet(cadet_id, token)
  			response= RestClient::Request.new(
	        :method => :put,
	        :url => "#{ENV['CADETS_URL']}cadets/#{cadet_id}/confirm",
	        :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
	    ).execute
  end

  def self.rejectCadet(cadet_id, token)
  			response= RestClient::Request.new(
	        :method => :delete,
	        :url => "#{ENV['CADETS_URL']}cadets/#{cadet_id}/reject",
	        :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
	    ).execute
  end
  
  def self.getConfirmationPendingCadets(token)
  			response= RestClient::Request.new(
	        :method => :get,
	        :url => "#{ENV['CADETS_URL']}cadets/pending",
	        :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
	    ).execute
  		pending_cadets = JSON.parse(response.to_str)
  		return pending_cadets
  end
end
