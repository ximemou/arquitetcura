class CadetsController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :authenticate_cadet!
  skip_before_action :authenticate_cadet!, :only => [:new, :create, :get_near_cadets, :index, :update, :show, :convert_cadet, :confirm_cadet, :reject_cadet, :get_pending_cadets], raise: false

  def index
    @cadets = Cadet.all
    resolve_format @cadets
  end

  def show
    id = params[:id].to_i
    @cadet = Cadet.get_cadet_by_id(id)
    resolve_format @cadet
  end

  def new
    @cadet = Cadet.new
  end

  def create
    begin
      @cadet = Cadet.new(cadet_params)
      @cadet.pending = true
      if @cadet.save
        CadetsHelper.save_cadet_session @cadet
        LogHelper.saveInfoInLog("Info: Se registro el cadete con los siguientes parametros: "+ @cadet.to_json)
        sign_in_and_redirect @cadet
        flash[:notice] = "Su solicitud ha sido enviada"
      else
        render "new"
      end
    rescue
      render "new"
      LogHelper.saveErrorInLog("Error: no se pudo crear el cadete con los siguientes parametros: "+ cadet_params.to_json)
    end
  end

  def edit
    @cadet = Cadet.find params[:id]
  end

  def update
    id = params[:id].to_i
    @cadet = Cadet.get_cadet_by_id(id)
    latitude = params[:latitude]
    longitude = params[:longitude]
    @cadet.latitude = latitude
    @cadet.longitude = longitude
    @cadet.save!
    resolve_format "{'status' : 'ok'}"
  end

  def destroy
    @cadet = Cadet.find(params[:id])
    @cadet.destroy
    redirect_to cadets_path
  end

  def get_near_cadets
    latitude = params[:originLatitude]
    longitude = params[:originLongitude]
    near_cadets = Cadet.get_near_cadets(latitude, longitude)
    resolve_format near_cadets
  end

  def convert_cadet
    id = params[:id].to_i
    cadet_to_convert = Cadet.get_cadet_by_id(id)
    cadet = Cadet.convert_cadet_to_send_email(cadet_to_convert)
    puts cadet
    resolve_format cadet
  end

  def delete_cadet_session
    CadetsHelper.delete_session(current_cadet.id)
    sign_out current_cadet
    redirect_to ENV['MAIN_URL']
  end

  def confirm_cadet
    authenticate_admin! || return
    cadet_id = params[:id]
    Cadet.confirm_cadet cadet_id
    resolve_format "{'status' : 'ok'}"
  end

  def reject_cadet
    authenticate_admin! || return
    cadet_id = params[:id]
    Cadet.reject_cadet cadet_id
    resolve_format "{'status' : 'ok'}"
  end

  def get_pending_cadets
    authenticate_admin! || return
    @cadets = Cadet.get_confirmation_pending_cadets
    resolve_format @cadets
  end

  private

  def cadet_params
    params.require(:cadet).permit(:name, :lastname, :email, :password,
                                  :id_card, :profile_image, :driver_license_image,
                                  :vehicle_information)
  end

  def resolve_format(obj)
    respond_to do |format|
      format.json { render :json => obj }
    end
  end
end
