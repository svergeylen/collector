module TagsHelper

	# Renvoie un lien vers le tag en ajoutant le chemin pour y accéder dans l'url
	def one_tag_path(tag, a)
		a ||= []
		return  link_to tag.name, tag_path(id: tag.id, a: a.join(",") )
	end

	# Concatène tag_string et tag.id et renvoie un lien vers le tag name en conservant le chemin parcouru pour y arriver
	def get_tag_path(tag)
		arr = session[:a].split(",")
		arr << tag.id.to_s
		return one_tag_path(tag, arr)
	end

	# Fait le rendu complet des breadcrumb pour un tag donné
	def breadcrumbs_for(tag_string)
		if tag_string.present?
			arr = tag_string.split(",")
			intermediate_tag_string = []
			tmp = '<ol class="breadcrumb">'
			# On parcourt la liste de tags (et PAS les tags qui ne sont pas renvoyés dans le même ordre par MySQL) 
			# en mémorisant le tag_string au fur et à mesure pour la génération des urls
			arr.each do |str| 
				id = str.to_i
				intermediate_tag_string << id
				tag = Tag.find(id)
				tmp += '<li class="breadcrumb-item">'+one_tag_path(tag, intermediate_tag_string)+'</li>'
			end
			tmp += '</ol>'
			return tmp.html_safe
		else
			return ""
		end
	end




end
