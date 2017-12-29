module TagsHelper

	# Renvoie un lien vers le tag en ajoutant le chemin pour y accéder dans l'url
	def one_tag_path(tag, arr)
		arr ||= []
		return  link_to tag.name, tags_path(a: arr.join(",") )
	end

	# Concatène tag_string et tag.id et renvoie un lien vers le tag name en conservant le chemin parcouru pour y arriver
	def get_tag_path(tag_string, tag)
		tag_string ||= ""
		arr = tag_string.split(",")
		arr << tag.id.to_s
		return one_tag_path(tag, arr)
	end

	# Fait le rendu pcomplet des breadcrumb pour un tag donné
	def breadcrumbs_for(tag_string)
		if tag_string.present?
			arr =tag_string.split(",")
			tags = Tag.where(id: arr)
			memo_ids = []
			tmp = '<ol class="breadcrumb">'
			# On parcourt la liste de tags en mémorisant le chemin au fur et à mesure pour la génération de l'url
			tags.map do |tag| 
				memo_ids << tag.id
				tmp += '<li class="breadcrumb-item">'+one_tag_path(tag, memo_ids)+'</li>'
			end
			tmp += '</ol>'
			return tmp.html_safe
		else
			return ""
		end
	end




end
