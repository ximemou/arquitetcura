Rails.application.routes.draw do


  post '/sessions', :to => 'sessions#save_user_session'

  get '/sessions/token', :to => 'sessions#get_token_session'

  delete '/sessions', :to => 'sessions#delete_session'

  get '/sessions', :to => 'sessions#get_session'

end
