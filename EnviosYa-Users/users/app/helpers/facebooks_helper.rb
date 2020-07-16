module FacebooksHelper
	  def self.save_user_session(user)
	  	role = 'user'
      response = RestClient.post "#{ENV['SESSIONS_URL']}sessions?role=#{role}",
        {"user" => user}.to_json,
        {accept: 'application/json',
        content_type: :json}
    end
end
