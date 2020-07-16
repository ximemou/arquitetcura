if Rails.env.development?
	#lo de la carpeta initializers se ejecuta cada vez que se inicia la app
	ENV['USERS_URL'] = "http://localhost:3002/"
	ENV['CADETS_URL'] = "http://localhost:3004/"
	ENV['SHIPMENTS_URL'] = "http://localhost:3005/"
	ENV['SESSIONS_URL'] = "http://localhost:3001/"
	ENV['DISCOUNTS_URL'] = "http://localhost:3003/"
	ENV['NOTIFICATIONS_URL'] = "http://localhost:3006/"
	ENV['ADMINS_URL'] = "http://localhost:3007/"
	ENV['MAIN_URL'] = "http://localhost:3000/"
else
	ENV['USERS_URL'] = "http://enviosya-users-moure-puricelli.mybluemix.net/"
	ENV['CADETS_URL'] = "http://enviosya-cadets-moure-puricelli.mybluemix.net/"
	ENV['SHIPMENTS_URL'] = "http://enviosya-shipments-moure-puricelli.mybluemix.net/"
	ENV['SESSIONS_URL'] = "http://enviosya-sessions-moure-puricelli.mybluemix.net/"
	ENV['DISCOUNTS_URL'] = "http://enviosya-discounts-moure-puricelli.mybluemix.net/"
	ENV['NOTIFICATIONS_URL'] = "http://enviosya-notifications-moure-puricelli.mybluemix.net/"
	ENV['ADMINS_URL'] = "http://enviosya-admins-moure-puricelli.mybluemix.net/"
	ENV['MAIN_URL'] = "http://enviosya-main-moure-puricelli.mybluemix.net/"
end