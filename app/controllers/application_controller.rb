class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # Force que l'utilisateur soit loggé pour tous les contoleurs
  before_action :authenticate_user!
  # Ajoute des paramètres modifiables par l'utilisateur dans Devise (strong Paramaters)
  before_action :configure_permitted_parameters, if: :devise_controller?


  # Renvoie un lien vers le dernier tag affiché (probablement), tout en conservant les tags actifs
  def last_tag_path
    if session[:active_tags].present?
  	 return tag_path(session[:active_tags].last)
    else
      return welcome_collector_path
    end
  end

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
		devise_parameter_sanitizer.permit(:account_update, keys: [:name])
		devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
		devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
	end

end
