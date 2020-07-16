class InvitationMailer < ApplicationMailer
	default from: 'EnviosYa'
  
	def send_invitation(email_to, sender_name, sender_lastname)
	  @sender_name = sender_name
	  @sender_lastname = sender_lastname
      @url  = 'http://www.gmail.com'   
      mail(to: email_to, subject: 'Invitacion EnviosYa')
   	end
end