class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # Force que l'utilisateur soit loggé pour tous les contoleurs
  before_action :authenticate_user!
  # Ajoute des paramètres modifiables par l'utilisateur dans Devise (strong Paramaters)
  before_action :configure_permitted_parameters, if: :devise_controller?

	# Remplace la liste des tags actifs par l'array de tags existants donné
	def set_active_tag_ids(active_tag_ids)
		session[:active_tags] = active_tag_ids
	end
	# Ajoute un tag actif à la liste, sans ajouter de doublon
	def add_active_tag_id(active_tag_id)
		session[:active_tags] = session[:active_tags] + [ active_tag_id.to_i ] unless session[:active_tags].include?(active_tag_id.to_i)
	end
	# Renvoie les ids de tags actifs
	def get_active_tag_ids
		return session[:active_tags]
	end
	# Renvoie les  tags actifs
	def get_active_tags
		return Tag.find(session[:active_tags])
	end
	#Renvoie le dernier tag ajouté au active tags
	def get_last_active_tag
		if session[:active_tags].length > 0
			return Tag.find(session[:active_tags].last)
		else
			return "no active tag"
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
