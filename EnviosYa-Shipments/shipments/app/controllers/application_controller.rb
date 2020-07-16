class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  @user
  @cadet

  def current_user
    return @user
  end

   def current_cadet
    return @cadet
  end

  def authenticate_user!

    token = params[:Authorization]
    user = ShipmentsHelper.validate_user(token, 'user')
    if(user)
      @user = user
      return true
    else
      flash[:notice] = 'No posee los permisos necesarios'
      redirect_to ENV['MAIN_URL'] 
      return false
    end
  end

  def authenticate_user_headers!

    token = request.headers['Authorization']
    user = ShipmentsHelper.validate_user(token, 'user')
    if(user)
      @user = user
      return true
    else
      flash[:notice] = 'No posee los permisos necesarios'
      redirect_to ENV['MAIN_URL'] 
      return false
    end
  end

    def authenticate_cadet!

    token = params[:Authorization]
    cadet = ShipmentsHelper.validate_user(token, 'cadet')
    if(cadet)
      @cadet = cadet
      return true
    else
      flash[:notice] = 'No posee los permisos necesarios'
      redirect_to ENV['MAIN_URL']
      return false
    end
  end

end
