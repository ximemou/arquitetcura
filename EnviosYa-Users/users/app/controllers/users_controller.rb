class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    authenticate_user!
    logged_user = current_user.id
    user_shipments = UsersHelper.get_user_shipments(logged_user)
    @send_shipments = []
    @received_shipments = []
    user_shipments.each do |s|
      if s['user_sender_id'] == logged_user
        @send_shipments.push(s)
      else
        @received_shipments.push(s)
      end
    end
  end

  def new
    set_user_params
  end

  def create
    begin
      @user=User.new(user_params)
      if CiUY.validate(@user.id_card)
        if @user.save
          LogHelper.save_info_in_log("Se ha registrado el usuario: " + @user.email)
          flash[:notice] = "Usuario creado"
          FacebooksHelper.save_user_session @user
          sign_in_and_redirect @user
        else
          respond_to do |format|
            format.html { render :new }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to new_user_path(user: JSON.parse(user_fb_params.to_json)), notice: 'Cedula de identidad no valida' }
        end
      end
    rescue
      LogHelper.save_error_in_log("Error: No se pudo crear un usuario con los siguiente parametros: "+user_params.to_json)
    end
  end

  def get_users_emails
    authenticate_token!
    users = User.pluck(:email)
    resolve_format users
  end

  def get_user_by_email
    user_email = params[:email]
    user = User.exits_user_by_email(user_email)
    resolve_format user
  end

  def show
    id = params[:id].to_i
    user = User.getUserById(id)
    resolve_format user
  end

  def create_shipment
    token = UsersHelper.get_user_token(current_user.id)
    redirect_to "#{ENV['SHIPMENTS_URL']}shipments/new?Authorization=#{token}"
  end

  def delete_user_session
    UsersHelper.delete_session(current_user.id)
    sign_out current_user
    redirect_to ENV['MAIN_URL']
  end

  private

  def user_fb_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

  def set_user_params
    @user = User.new(user_fb_params)
    last_name = @user.name.split(' ')
    @user.name = last_name[0]
    @user.lastname = last_name[1]
  end

  def save_user_auth(user)
    provider = session[:auth]["provider"]
    uid = session[:auth]["uid"]
    user.authorizations.build :provider => provider, :uid => uid
    user.save!
    session[:auth] = nil
  end

  def user_params
    params.require(:user).permit(:name, :lastname, :email,
                                 :id_card, :profile_image)
  end

  def resolve_format(obj)
		respond_to do |format|
          format.json { render :json => obj }
		end
  end
end