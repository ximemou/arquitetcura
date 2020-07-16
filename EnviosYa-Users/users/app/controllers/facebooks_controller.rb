class FacebooksController < Devise::OmniauthCallbacksController

  require 'json'
  def new
  end

  def index
	end

  def failure
    render :text => "Sorry, but you didn't allow access to our app!"
  end

  def facebook
    auth_hash = request.env['omniauth.auth']
    @user = nil
    user_registered= User.find_by_email(auth_hash["info"]["email"])
    if user_registered
      LogHelper.save_info_in_log("Se ha logueado el usuario: "+user_registered.email)
      if user_signed_in?
        redirect_to users_path
      else
        FacebooksHelper.save_user_session user_registered
        sign_in_and_redirect user_registered
      end
    else
      @user = User.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"], :profile_image => auth_hash["info"]["image"]
      session[:auth] =  {:provider => auth_hash["provider"], :uid => auth_hash["uid"]}
      modify_and_redirect(@user)
    end
  end

  def destroy
    id = params[:id]
    UsersHelper.delete_session(id)
  end

  private

  def modify_and_redirect(user)
    redirect_to new_user_path(user: JSON.parse(user.attributes.to_json))
  end
end
