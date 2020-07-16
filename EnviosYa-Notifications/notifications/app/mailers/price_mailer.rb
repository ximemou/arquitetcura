class PriceMailer < ApplicationMailer
  default from: 'EnviosYa'

  def send_price_notification_email(email_to, shipment)
    @shipment=shipment
    @url  = 'http://www.gmail.com'
    mail(to: email_to, subject: 'Precio final de envio')
  end
end