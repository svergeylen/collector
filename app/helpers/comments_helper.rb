module CommentsHelper

	# Renvoie une classe différente si l'utilisateur s'est déjà loggé avant ou après le commentaire
	def old_comment(d, user) 
		if d
			if (user.last_sign_in_at < d)
				# Il y a des nouveaux commentaires
				ret = "btn-primary"
			else
				ret = "btn-secondary"
			end
		else
			ret = "btn-secondary"
		end
		return ret
	end

end
