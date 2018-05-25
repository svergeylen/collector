class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # Force que l'utilisateur soit loggé pour tous les contoleurs
  before_action :authenticate_user!
  # Ajoute des paramètres modifiables par l'utilisateur dans Devise (strong Paramaters)
  before_action :configure_permitted_parameters, if: :devise_controller?

	# Mémorise le dernier chemin de folders suivi par l'utilisateur pour le rediriger au même endroit quand nécessaire
	def set_session_breadcrumbs(bc)
		session[:bc] = bc
	end

	def get_session_breadcrumbs
		return session[:bc]
	end

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
		devise_parameter_sanitizer.permit(:account_update, keys: [:name])
		devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
		devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
	end

end
