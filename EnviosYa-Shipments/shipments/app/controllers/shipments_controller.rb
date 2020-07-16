class ShipmentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
    authenticate_user!
    @token = params[:Authorization]
    @logged_user = current_user
    @user_cache = ShipmentsHelper.get_users_for_cache(@token)
    @shipment = Shipment.new
    @discount = ShipmentsHelper.get_discount
    @payment_types = Shipment.payment_types
    @applies_discount = ShipmentsHelper.has_discount(current_user['email'])
  end

  def create
    authenticate_user!
    begin
      user_receiver_email = params[:user_receiver_email]
      token = params[:Authorization]
      user_receiver = ShipmentsHelper.exits_user_by_email(user_receiver_email, token)
      if user_receiver
        @shipment = Shipment.create!(shipment_params)
        origin_address = params[:originCoordinates].split(', ')
        @shipment.origin_latitude = origin_address[0][1, origin_address[0].length]
        @shipment.origin_longitude = origin_address[1][0, origin_address[1].length-1]
        destination_address = params[:destinationCoordinates].split(', ')
        @shipment.destination_latitude = destination_address[0][1, destination_address[0].length]
        @shipment.destination_longitude = destination_address[1][0, destination_address[1].length-1]
        @shipment.delivered = false
        @shipment.shipment_solicitude_time = Time.zone.now
        @shipment.commission = 10
        @shipment.user_receiver_id = user_receiver['id'].to_i
        @shipment.user_sender_id = current_user['id'].to_i
        if ShipmentsHelper.verify_discount(current_user['email'])
          @shipment.applies_discount = true
          if @shipment.estimated_price
            @shipment.estimated_price = ShipmentsHelper.calculate_price_with_discount(@shipment.estimated_price)
          else
            @shipment.price = ShipmentsHelper.calculate_price_with_discount(@shipment.price)
          end
        else
          @shipment.applies_discount = false
        end
        @shipment.save!
        LogHelper.save_info_in_log("INFO: Se registro un envio con los siguientes parametros: " + @shipment.to_json)
        flash[:notice] = "Envío realizado"
        redirect_to "#{ENV['USERS_URL']}users"
      else
        flash[:notice] = "No existe el usuario al que quiere realizar el envio"
      end
    rescue
      LogHelper.save_error_in_log("Error: no se puso crear un envio con los siguientes parametros: " + shipment_params.to_json)
    end
  end

  def confirm_reception_shipment
    authenticate_cadet!
    @token = params[:Authorization]
    shipment_id = params[:id].to_i
    logged_cadet = current_cadet['id'].to_i
    @shipment = Shipment.get_shipment_by_id_and_cadet(logged_cadet, shipment_id)
    begin
      if @shipment
        @shipment.update_attributes!(shipment_confirmation_params)
        @shipment.delivered = true
        @shipment.shipment_delivery_time = Time.zone.now
        @shipment.save!
        ShipmentsHelper.update_cadet_location(logged_cadet, @shipment.destination_latitude, @shipment.destination_longitude)
        sender_user = ShipmentsHelper.get_user_by_id(@shipment.user_sender_id)
        receiver_user = ShipmentsHelper.get_user_by_id(@shipment.user_receiver_id)
        cadet = ShipmentsHelper.get_cadet_by_id(logged_cadet)
        cadet_to_send = ShipmentsHelper.convert_cadet(logged_cadet)
        shipment_email = Shipment.convert_shipment_to_send_email(@shipment)
        @recipients = [sender_user['email'], receiver_user['email']]
        shipment_payment_type = Shipment.get_payment_type(@shipment.payed_by)
        url_image = @shipment.receiver_signature_image_url
        puts url_image
        NotificationJob.perform_later(@recipients, sender_user, receiver_user, shipment_email, cadet_to_send, shipment_payment_type, url_image)
        redirect_to shipments_path+ "?cadetId=" + logged_cadet.to_s + "&Authorization=#{@token}"
      else
        flash[:notice] = 'No tiene los permisos para confirmar el envio'
      end
    rescue
      LogHelper.save_error_in_log("Error: no se pudo confirmar el envio cuyos datos son: " + @shipment.to_json)
    end
  end

  def display_shipment_reception_form
    authenticate_cadet!
    @token = params[:Authorization]
    @shipment_id = params[:id]
  end

  def show_shipment_details
    authenticate_cadet!
    @token = params[:Authorization]
    shipment_id = params[:id].to_i
    @logged_cadet = current_cadet['id']
    shipment = Shipment.get_shipment_by_id_and_cadet(@logged_cadet, shipment_id)
    if shipment
      @sender_user = ShipmentsHelper.get_user_by_id(shipment.user_sender_id)
      @receiver_user = ShipmentsHelper.get_user_by_id(shipment.user_receiver_id)
      @shipment = shipment
    else
      flash[:notice] = 'No tiene los permisos para ver los detalles de este envio'
    end
  end

  def show_cadet_shipments
    authenticate_cadet! || return
    @token = params[:Authorization]
    if current_cadet['id'].to_i == params[:cadetId].to_i
    @cadet = current_cadet
    shipments = Shipment.get_cadet_shipments(current_cadet['id'])
    @pending_shipments = []
    @delivered_shipments = []
    shipments.each do |s|
      if s.delivered
        @delivered_shipments.push(s)
      else
        @pending_shipments.push(s)
      end
    end
    else
      flash[:notice] = 'No tiene los permisos para ver los envios del cadete'
    end
  end

  def get_user_shipments
    authenticate_user_headers!
    user_id = params[:id]
    shipments = Shipment.get_user_shipments(user_id)
    resolve_format shipments
  end

  def shipment_params
    params.require(:shipment).permit(:origin_postal_code, :destination_postal_code,
                                     :cadet_id, :estimated_price, :price, :payed_by, :package_weight, :origin_address, :destination_address,
                                     :Authorization)
  end

  private

  def shipment_confirmation_params
    params.require(:shipment).permit(:receiver_signature_image)
  end

  def resolve_format(obj)
    respond_to do |format|
      format.json { render :json => obj }
    end
  end
end
