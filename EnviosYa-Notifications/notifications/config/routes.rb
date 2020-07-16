Rails.application.routes.draw do

   get '/mailer/invite', :to => 'mailer#send_invitation'

   get '/mailer/status_notification', :to => 'mailer#send_status_notification'

   post '/mailer/price_notification', :to => 'mailer#send_price_notification_email'

   post '/mailer/shipment_confirmation', :to =>	'mailer#send_confirmation_mail'

end
