class Shipment < ApplicationRecord

  mount_uploader :receiver_signature_image, ImageUploader
  enum payment_type: [:sender,:receiver,:both]
  def self.get_cadet_shipments(cadet_id)
     return where(cadet_id: cadet_id)
  end

  def self.get_shipment_by_id_and_cadet(cadet_id,shipment_id)
    return where(["id= :id and cadet_id= :cadet_id",{id:shipment_id, cadet_id:cadet_id}]).first()
  end

  def self.get_payment_type(payed_by)
    payed = payment_types.key(payed_by)
     case payed
         when "sender"
           "Paga el remitente"
         when "receiver"
           "Paga el destinatario"
         when "both"
           "Pagan remitente y destinatario a partes iguales"
     end
  end

  def self.convert_shipment_to_send_email(shipment)
    shipment.shipment_solicitude_time = shipment.shipment_solicitude_time.as_json
    shipment.shipment_delivery_time = shipment.shipment_delivery_time.as_json
    return shipment

  end

  def self.get_shipments_without_final_price()
    shipments = where(price: nil)
    return shipments
  end

  def self.update_final_price(shipment_id,price)
    shipment = find(shipment_id)
    shipment.price = price
    shipment.save!
  end

  def self.get_user_shipments(id_user)
    shipments = where(["user_sender_id= :user_sender_id or user_receiver_id= :user_receiver_id",{user_sender_id: id_user, user_receiver_id: id_user}])
    return shipments
  end

end