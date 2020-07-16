class CadetMailer < ApplicationMailer
	default from: 'EnviosYa'
  def send_status_notification(cadet_email, accepted)
    @accepted=accepted
    @url  = 'http://www.gmail.com'
    mail(to: cadet_email, subject: 'Estado de registro en EnviosYa')
  end
end