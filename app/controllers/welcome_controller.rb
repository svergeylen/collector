class WelcomeController < ApplicationController

	skip_before_action :authenticate_user!

	# Accueil du site vergeylen.eu
	# PAS d'authentificationr requise
	def index
		month = Time.now.strftime('%m')
		case month
			when "10"
				@image_name = "logos/halloween.png"
			when "12"
				@image_name = "logos/noel.png"
			else
				@image_name = "logos/"+(1 + rand(2)).to_s+".png"
		end

		render template: "welcome/index", layout: false
	end

	# Accueil du Collector
	# PAS d'authentificationr requise
	def collector
	    session[:active_tags] = []
	    @root_tags = Tag.where(root_tag: true).order(name: :asc)
	end
end
