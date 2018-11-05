module UsersHelper

	# Returns avatar of the user in correct format for diplay next to messages, comments
	def profile_picture(user, quantity = 0)
		ret = ""
		if quantity > 1
			ret += quantity.to_s+"x "
		end
		ret+= link_to user do 
			image_tag 	user.friendly_avatar_url, 
						alt: "Utilisateur: #{user.name}",
						title: user.name,
						class: 'profile-picture'
		end
		return ret.html_safe
	end

end
