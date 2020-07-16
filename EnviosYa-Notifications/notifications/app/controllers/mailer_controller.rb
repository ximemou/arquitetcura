class MailerController < ApplicationController
	skip_before_action :verify_authenticity_token
	def send_invitation
		email_from = params[:email_from]
		email_to = params[:email_to]
		name_from = params[:name_from]
		lastname_from = params[:lastname_from]
		InvitationMailer.send_invitation(email_to, name_from, lastname_from).deliver_later
		MailerHelper.create_discount(email_to, email_from)
		LogHelper.saveInfoInLog("Info: Se envio un mail de invitacion a #{email_to}")
		redirect_to "#{ENV['USERS_URL']}users"
	end

	def send_status_notification
		cadet_email = params[:email] 
		accepted = params[:accepted]
		accepted_bool = MailerHelper.convert_to_bool(accepted)
		CadetMailer.send_status_notification(cadet_email, accepted_bool).deliver_later
		LogHelper.saveInfoInLog("Info: Se envio un mail de notificacion a #{cadet_email}")
	end

	def send_price_notification_email
		email_to = params[:email_to]
		shipment = JSON.parse(request.raw_post)['shipment']
		PriceMailer.send_price_notification_email(email_to, shipment).deliver_later
		LogHelper.saveInfoInLog("Info: Se envio un mail de actualizacion de precio a #{email_to}")
	end
	
	def send_confirmation_mail
		recipients =  JSON.parse(request.raw_post)['recipients']
		sender_user =  JSON.parse(request.raw_post)['sender_user']
		receiver_user =  JSON.parse(request.raw_post)['receiver_user']
		shipment_details = JSON.parse(request.raw_post)['shipment']
		cadet =  JSON.parse(request.raw_post)['cadet']
		payed_by =  JSON.parse(request.raw_post)['payed_by']
		url_image = JSON.parse(request.raw_post)['url_image']
		ConfirmationMailer.send_confirmation_mail(recipients,sender_user,receiver_user, shipment_details,cadet, payed_by, url_image).deliver_later
		LogHelper.saveInfoInLog("Info: Se envio un mail de confirmacion de envio a #{recipients.to_json}")
	end
end
