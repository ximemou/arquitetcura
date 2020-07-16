class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    def after_sign_in_path_for(resource)
    	CadetsHelper.save_cadet_session(current_cadet)
    	token = CadetsHelper.get_cadet_token(current_cadet.id, 'cadet')
	    if(resource.class==Cadet)
	      ENV['SHIPMENTS_URL'] +"shipments/?cadetId="+current_cadet.id.to_s+"&Authorization=#{token}"
	     end
  	end

  	def authenticate_admin!
	    token = request.headers['Authorization']
	    user = CadetsHelper.validate_user(token, 'admin')
	    if(user)
	      return true
	    else
	      flash[:notice] = 'No posee los permisos necesarios'
     	  redirect_to ENV['MAIN_URL']
     	  return false
	    end
  	end
end
