class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
 def after_sign_in_path_for(resource)
  if(resource.class==User)
      users_path
  end
end

	def authenticate_token!
		token = request.headers['Authorization']
		return UsersHelper.validate_user_token(token)
	end
end
