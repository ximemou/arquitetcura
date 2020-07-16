Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  get '/shipments', :to => 'shipments#show_cadet_shipments'

  get '/shipments/new' , :to=>'shipments#new'
  post '/shipments',:to=>'shipments#create'
  get '/shipments/user', :to => 'shipments#get_user_shipments'

  get '/shipments/:id', :to=>'shipments#show_shipment_details'

  get '/shipments/:id/confirm', :to=>'shipments#display_shipment_reception_form'

  put 'shipments/:id/confirm', :to=> 'shipments#confirm_reception_shipment'


  get 'shipping-rates', :to=> 'rates#get_shipping_cost'





end

