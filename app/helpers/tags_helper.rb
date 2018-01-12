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
	def breadcrumbs_for(tag_string, children_quantity)
		children_quantity ||= 0

		if tag_string.present?
			arr = tag_string.split(",")
			intermediate_tag_string = []
			tmp = '<ol class="breadcrumb">'
			# On parcourt le tagstring (et PAS les objects "tags" car ils ne sont pas renvoyés dans le bon ordre par MySQL) 
			# en mémorisant le tag_string au fur et à mesure pour la génération des urls
			arr.each_with_index do |str, index| 
				id = str.to_i
				highlight_last = (index == (arr.size-1)) ? "last" : ""
				intermediate_tag_string << id
				tag = Tag.find(id)
				tmp += '<li class="breadcrumb-item '+ highlight_last + '">' + one_tag_path(tag, intermediate_tag_string)+'</li>'
			end

		# Affichage du champ "filtre" si plus de 20 tags enfants
		if children_quantity > 20
			tmp += '<form action="#" method="get" class="inline-form form-in-breadcrumbs">'
			tmp += text_field_tag(:tag_filter, "", { placeholder: "Filtrer", class: 'form-control input-sm', autocomplete: 'off'})	
			tmp += '</form>'
	  	end


			tmp += '</ol>'
			return tmp.html_safe
		else
			return ""
		end
	end




end
