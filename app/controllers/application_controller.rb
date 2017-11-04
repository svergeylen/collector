class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # Force que l'utilisateur soit loggé pour tous les contoleurs
  before_action :authenticate_user!
  # Ajoute des paramètres modifiables par l'utiliateur dans Devise (strong Paramaters)
  before_action :configure_permitted_parameters, if: :devise_controller?


	# Mémorise la dernière catégorie choisie par l'utilisateur (catégorie courante)
	def set_session_category(cat)
		session[:category_id] = cat.id
		session[:category_name] = cat.name
	end


	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
		devise_parameter_sanitizer.permit(:account_update, keys: [:name])
		devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
		devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
	end

end
