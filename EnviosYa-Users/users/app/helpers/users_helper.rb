module UsersHelper


  def self.get_user_shipments(logged_user)
  user_token = get_user_token(logged_user)
  response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['SHIPMENTS_URL']}shipments/user?id=#{logged_user}",
        :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => user_token}
    ).execute
    user_shipments = JSON.parse(response.to_str)
  end

  def self.get_user_token(logged_user)
    role = 'user'
    response= RestClient::Request.new(
          :method => :get,
          :url => "#{ENV['SESSIONS_URL']}sessions/token?user_id=#{logged_user}&role=#{role}",
          :headers =>  {:accept => 'application/json', :content_type => :json}
      ).execute
      user_token = response.to_str
      return user_token
  end

  def self.delete_session(id)
  token = get_user_token(id)
  response= RestClient::Request.new(
        :method => :delete,
        :url => "#{ENV['SESSIONS_URL']}sessions",
        :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
    ).execute
  end

  def self.validate_user_token(token)
  response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['SESSIONS_URL']}sessions",
        :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
    ).execute
    session = JSON.parse(response.to_str)
    if(session)
      return true
    else
      return false
    end
  end

  def self.get_user_shipments(user_id)
    token = get_user_token(user_id)
    response= RestClient::Request.new(
          :method => :get,
          :url => "#{ENV['SHIPMENTS_URL']}shipments/user?id=#{user_id}",
          :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
      ).execute
      shipments = JSON.parse(response.to_str)
      return shipments
  end

end
