Rails.application.routes.draw do

  get '/cadets/pending' , :to => 'cadets#get_pending_cadets'

  devise_for :cadets
  resources :cadets

  get '/cadets/:id/convert', :to => 'cadets#convert_cadet'
  post '/cadets/nearestCadets', :to => 'cadets#get_near_cadets'
  delete '/token/cadets', :to => 'cadets#delete_cadet_session'
  put '/cadets/:id/confirm', :to => 'cadets#confirm_cadet'
  delete '/cadets/:id/reject', :to => 'cadets#reject_cadet'

end
