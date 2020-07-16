Rails.application.routes.draw do
  devise_for :admins

  put '/admins/confirmCadet', :to=> 'admins#acceptCadet'

  get 'admins/index', :to=> 'admins#showCadets'

  delete 'admins/rejectCadet', :to=> 'admins#rejectCadet'

  delete '/token/admins', :to => 'admins#delete_admin_session'

end
