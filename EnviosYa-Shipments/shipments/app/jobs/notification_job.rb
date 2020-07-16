class NotificationJob < ApplicationJob
  queue_as :default

  def perform(recipients,sender_user, receiver_user,shipment_email,cadet_to_send, shipment_payment_type, url_image)
    ShipmentsHelper.send_confirmation_mail(recipients,sender_user, receiver_user,shipment_email,cadet_to_send, shipment_payment_type, url_image)
  end
end
