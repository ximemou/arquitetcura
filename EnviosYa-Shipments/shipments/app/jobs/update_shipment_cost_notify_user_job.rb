class UpdateShipmentCostNotifyUserJob < ApplicationJob
  queue_as :default

  def perform(*args)
    shipments=Shipment.get_shipments_without_final_price
    shipments.each do |shipment|
      price=RatesHelper.calculate_final_cost_when_api_working(shipment)
      user=ShipmentsHelper.get_user_by_id(shipment.user_sender_id)
      price_with_discount=price
      if(ShipmentsHelper.verify_discount(user['email']))
        price_with_discount=ShipmentsHelper.calculate_price_with_discount(price)
      end
      Shipment.update_final_price(shipment.id, price_with_discount)
      shipment_updated = Shipment.find(shipment.id)
      LogHelper.save_info_in_log("Se ha actualizado el precio final del envio: "+shipment.id.to_s )
      ShipmentsHelper.send_price_notification_email(user['email'],shipment_updated)
      LogHelper.save_info_in_log("Se ha mandado el mail de notificacion del precio final al usuario  "+user['email']+" por el envio "+ shipment.id.to_s)
    end
  end
end