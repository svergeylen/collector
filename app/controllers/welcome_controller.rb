class WelcomeController < ApplicationController

	# Accueil du site vergeylen.eu
	def index
		# Logo
		month = Time.now.strftime('%m')
		@image_name = "logos/"+month.to_s+".png"

		# Badges d'indication de nouveaux messages
		# Ici, je prends post.updated_at car les comments touch les posts (updated_at)
		@counter_la_une = current_user.displayed_la_une.nil? ? 0 : Post.where("updated_at >= :date", date: current_user.displayed_la_une).count
		# Pour les Items, je mets item.created_at pour éviter de générer un badge lorsqu'on modifie un item existant
		@counter_collector = current_user.displayed_collector.nil? ? 0 : Item.where("created_at >= :date", date: current_user.displayed_collector).count
	end

	# Accueil du Collector
	def collector
		# Efface tous les active tags lorsqu'on va à l'accueil du collector
	    session[:active_tags] = []

	    # Mémorise l'heure de l'affichage du Collector pour le compteur en première page
    	current_user.displayed_collector = Time.now
    	current_user.save

	    @root_tags = Tag.where(root_tag: true).order(name: :asc)
	end
end
