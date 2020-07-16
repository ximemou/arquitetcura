module MailerHelper
	def self.get_discount
    response= RestClient::Request.new(
        :method => :get,
        :url => "#{ENV['DISCOUNTS_URL']}discounts",
        :headers =>  {:accept => 'application/json', :content_type => :json}
    ).execute
    discount = response.to_str
    return discount.to_i
  end

  def self.create_discount(receiver_email, sender_email)
		response = RestClient.post "#{ENV['DISCOUNTS_URL']}discounts?receiver_email=#{receiver_email}&sender_email=#{sender_email}",
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
