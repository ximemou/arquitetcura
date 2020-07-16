class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  @user
  def after_sign_in_path_for(resource)
    if resource.class == Admin
      AdminsHelper.save_admin_session(current_admin)
      token = AdminsHelper.get_admin_token(current_admin.id, 'admin')
      admins_index_path + "?Authorization=#{token}"
    end
  end

  def authenticate_admin!
    token = params[:Authorization]
    user = AdminsHelper.validate_user(token, 'admin')
    if user
      return true
    else
      flash[:notice] = 'No posee los permisos necesarios'
      redirect_to ENV['MAIN_URL']
      return false
    end
  end
end
