class UsersController < ApplicationController
	def show
  		@user = User.find(params[:id])
  		
  		# Derniers messages
  		@last_post = @user.posts.order(created_at: :desc).limit(1).first

  		# Derniers ajouts Collector
  		@months_quantity = 6
  		@items = @user.last_added_items(@months_quantity)
	end

	# Montre les séries suivies et les prochains numéro à acquérir
	def favorites
		@series = current_user.series.order(name: :asc)


		# Item.all.each do |item|
	 #  		item.number = item.numero.to_f
	 #  		item.save
	 #  	end



	end

	# Supprimer l'image de profil
	def delete_profile_picture
		if (current_user.id == params[:id].to_i) 
			logger.debug "egaux"
			current_user.avatar = nil
			current_user.save
			redirect_to current_user, notice: "Image de profil supprimée"
		else 
			logger.debug "different"
			redirect_to current_user, error: "Vous ne pouvez pas supprimer l'avatar d'un autre utilisateur"
		end

	end
end
