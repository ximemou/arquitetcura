class SessionsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def save_user_session
		user = JSON.parse(request.raw_post)['user']
		role = params[:role]
		if (Session.validate_user_not_logged(user, role))
			Session.create!(:user => user, :role => role)
			LogHelper.saveInfoInLog("Se creo la sesion")
			resolve_format "{'status' : 'ok'}"
		else
			flash[:notice] = 'Error de rol'
			LogHelper.saveErrorInLog("ERROR: El rol no es correcto")
		end
	end

	def get_session
		token = request.headers[:Authorization]
		session = Session.get_session_by_token(token)
		resolve_format session
	end

	def get_token_session
		user_id = params[:user_id].to_i
		role = params[:role]
		token = Session.get_token_by_id_and_role(user_id, role)
		resolve_format token
	end

	def delete_session
		token = request.headers[:Authorization]
		Session.delete_session(token)
		resolve_format "{'status' : 'ok'}"
	end
	
	private
	def resolve_format(obj)
    	respond_to do |format|
      		format.json { render :json => obj }
       	end
 	 end
end