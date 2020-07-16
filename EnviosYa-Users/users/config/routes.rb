Rails.application.routes.draw do

  get '/users/emails', :to => 'users#get_users_emails'

  get '/users/email', :to => 'users#get_user_by_email'

  resources :users
  devise_for :users, :controllers => { :omniauth_callbacks => "facebooks" }

  get '/token/shipments', :to => 'users#create_shipment'

  delete '/token/users', :to => 'users#delete_user_session'

end