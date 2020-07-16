module CadetsHelper
	def self.save_cadet_session(cadet)
      response = RestClient.post "#{ENV['SESSIONS_URL']}sessions?role=cadet",
        {"user" => cadet}.to_json,
        {accept: 'application/json',
        content_type: :json}
    end

	def self.get_cadet_token(logged_user, role)
		response= RestClient::Request.new(
	        :method => :get,
	        :url => "#{ENV['SESSIONS_URL']}sessions/token?user_id=#{logged_user}&role=#{role}",
	        :headers =>  {:accept => 'application/json', :content_type => :json}
	    ).execute
	    user_token = response.to_str
	    return user_token
	end	

    def self.delete_session(id)
	token = get_cadet_token(id, 'cadet')
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

  def self.send_status_notification(cadet_email, accepted)
  			response= RestClient::Request.new(
	        :method => :get,
	        :url => "#{ENV['NOTIFICATIONS_URL']}mailer/status_notification?email=#{cadet_email}&accepted=#{accepted}",
	        :headers =>  {:accept => 'application/json', :content_type => :json}
	    ).execute
  end
  
end
