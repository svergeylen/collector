module PostsHelper

	# Renvoie "post-old" si l'utilisateur s'est déjà loggué après la date du post
	# ET si il n'y a plus aucun commentaire nouveau ajouté
	def old_post(post, user) 
		if (user.last_sign_in_at < post.updated_at)
			ret = "post-new"
		else
			# Vérification des commentaires
			if (post.last_commented_at and user.last_sign_in_at < post.last_commented_at)
				ret = "post-new"
			else
				ret = "post-old"
			end
		end
		return ret
	end
end
