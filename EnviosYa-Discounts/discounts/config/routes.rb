Rails.application.routes.draw do

	get '/discounts', :to => 'discounts#get_discount'
	post '/discounts', :to => 'discounts#create_discount'
	get '/discounts/calculatePrice', :to => 'discounts#calculate_price_with_discount'
	put '/discounts/verifyDiscount', :to => 'discounts#verify_discount'
	get '/discounts/hasDiscount', :to => 'discounts#has_discount'

end
