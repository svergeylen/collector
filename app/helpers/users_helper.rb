module UsersHelper

	# Returns avatar of the user in correct format for diplay next to messages, comments
	def profile_picture(user)
		link_to user do 
			image_tag 	user.friendly_avatar_url, 
							alt: "Utilisateur: #{user.name}",
							title: user.name,
							class: 'profile-picture'
		end
	end

end
