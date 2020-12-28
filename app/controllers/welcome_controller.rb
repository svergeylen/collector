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
  	current_user.save_time_collector
    @folders = Folder.roots.order('lower(name)')
	end
end
