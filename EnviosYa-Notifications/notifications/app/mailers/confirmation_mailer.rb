class ConfirmationMailer < ApplicationMailer
	default from: 'EnviosYa'
   
	def send_confirmation_mail(recipients,sender_user,receiver_user, shipment_details,cadet, payed_by, url_img)
	  @shipment_details = shipment_details
		@sender_user = sender_user
		@receiver_user = receiver_user
    @payed_by = payed_by
    @cadet = cadet
		@url_img = ENV['SHIPMENTS_URL'] + url_img
		@url = 'http://www.gmail.com'
		@discount = MailerHelper.get_discount
    attachments["recibo.pdf"] = WickedPdf.new.pdf_from_string(
				render_to_string(template: "confirmation_mailer/receipt.html.erb",
												       locals: {:shipment_details => @shipment_details, :sender_user => @sender_user,
								               :receiver_user => @receiver_user,:cadet => @cadet,:payed_by => @payed_by, :url_img => @url_img ,:discount => @discount} ))
		mail(to:recipients , subject: 'Resumen de envio EnviosYa')
	end
end