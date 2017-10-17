module UsersHelper

	# Returns avatar of the user in correct format for diplay next to messages, comments
	def profile_picture(user)
		link_to user do 
			image_tag 	user.avatar.url(:tiny), 
							alt: "Utilisateur: #{user.name}",
							title: user.name,
							class: 'profile-picture'
		end
	end

	# Renvoie le nom d'un item récemment ajouté
	def name_for(item)
		ret = item.series.name + " - " + item.name
		ret += " (n°"+item.numero+")" if item.numero.present?
	end
end
