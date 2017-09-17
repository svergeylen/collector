class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

	# Mémorise la dernière catégorie choisie par l'utilisateur (catégorie courante)
	def set_session_category(id)
		session[:category] = id
	end

end
