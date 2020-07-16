module ShipmentsHelper
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

  def self.get_users_for_cache(token)
    response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['USERS_URL']}users/emails",
        :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
    ).execute
    users = JSON.parse(response.to_str)
    return users
  end

  def self.exits_user_by_email(user_receiver_email, token)
    response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['USERS_URL']}users/email?email=#{user_receiver_email}",
        :headers =>  {:accept => 'application/json', :content_type => :json, :Authorization => token}
    ).execute
    user = JSON.parse(response.to_str)
    return user
  end

  def self.get_discount
    response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['DISCOUNTS_URL']}discounts",
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
    discount = response.to_str
    return discount.to_i
  end

  def self.has_discount(email)
    response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['DISCOUNTS_URL']}discounts/hasDiscount?email=#{email}",
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
    applies_discount = JSON.parse(response.to_str)
    discount_bool = applies_discount['has_discount']
    return discount_bool
  end

  def self.verify_discount(email)
    response= RestClient::Request.new(
        :method => :put,
        :url => "#{ENV['DISCOUNTS_URL']}discounts/verifyDiscount?email=#{email}",
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
    applies_discount = JSON.parse(response.to_str)
    discount_bool = applies_discount['verify_discount']
    return discount_bool
  end

  def self.calculate_price_with_discount(price)
    response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['DISCOUNTS_URL']}discounts/calculatePrice?price=#{price}",
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
    price_with_discount = response.to_str
    return price_with_discount.to_f
  end

  def self.get_user_by_id(id)
    response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['USERS_URL']}users/#{id}",
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
    user = JSON.parse(response.to_str)
    return user
  end

  def self.get_cadet_by_id(id)
    response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['CADETS_URL']}cadets/#{id}",
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
    cadet = JSON.parse(response.to_str)
    return cadet
  end

  def self.convert_cadet(id)
    response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['CADETS_URL']}cadets/#{id}/convert",
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
    cadet = JSON.parse(response.to_str)
    return cadet
  end

  def self.update_cadet_location(id, lat, lng)
    response= RestClient::Request.new(
        :method => :put,
        :url => "#{ENV['CADETS_URL']}cadets/#{id}?latitude=#{lat}&longitude=#{lng}",
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
  end

  def self.send_price_notification_email(email, shipment)
      response = RestClient.post "#{ENV['NOTIFICATIONS_URL']}mailer/price_notification?email_to=#{email}",
        {"shipment" => shipment}.to_json,
        {accept: 'application/json',
        content_type: :json}
  end

  def self.send_confirmation_mail(recipients,sender_user, receiver_user,shipment_email,cadet_to_send, shipment_payment_type, url_image)
      response = RestClient.post "#{ENV['NOTIFICATIONS_URL']}mailer/shipment_confirmation",
        {"recipients" => recipients, 
          "sender_user" => sender_user,
          "receiver_user" => receiver_user,
          "shipment" => shipment_email,
          "cadet" => cadet_to_send,
          "payed_by" => shipment_payment_type,
          "url_image" => url_image}.to_json,
        {accept: 'application/json',
        content_type: :json}
  end
  
  def self.convert_to_bool(data)
    if(data == 'true')
      return true
    else
      return false
    end
  end
end
