module FoldersHelper

	# Renvoie un lien vers le folder en ajoutant le chemin pour y accéder dans l'url
	def one_folder_path(folder, bc)
		bc ||= []
		return  link_to folder.name, folder_path(id: folder.id, bc: bc.join(",") )
	end

	# Concatène folder_string et folder.id et renvoie un lien vers le folder name en conservant le chemin parcouru pour y arriver
	# DEPRECATED : ne servira que pour partager "SHARE" des liens par email
	def get_folder_path(folder)
		arr = []
		arr = session[:bc].split(",")
		arr << folder.id.to_s
		return one_folder_path(folder, arr)
	end

	# Fait le rendu complet des breadcrumb pour un chemin donné. bc = session[:bc]
	def breadcrumbs_for(bc, children_quantity)
		children_quantity ||= 0

		if bc.present?
			arr = bc
			intermediate_folder_string = []
			tmp = '<ol class="breadcrumb"><li>'
			tmp+= link_to "Collector", folders_path
			tmp+= '</li>'

			# On parcourt la liste bc pour générer la liste de breadcrumb de chaque folder intermédiaire
			arr.each_with_index do |str, index| 
				id = str.to_i
				highlight_last = (index == (arr.size-1)) ? "last" : ""
				intermediate_folder_string << id
				if Folder.exists?(id)
					folder = Folder.find(id)
					tmp += '<li class="breadcrumb-item '+ highlight_last + '">' + one_folder_path(folder, intermediate_folder_string)+'</li>'
				else
					tmp += '<li class="breadcrumb-item>??</li>'
				end

			end

			# Affichage du champ "filtre" si plus de 2 folders enfants
			if children_quantity > 20
				tmp += '<form action="#" method="get" class="inline-form form-in-breadcrumbs">'
				tmp += text_field_tag(:folder_filter, "", { placeholder: "Filtrer", class: 'form-control input-sm', autocomplete: 'off'})	
				tmp += '</form>'
		  	end


			tmp += '</ol>'
			return tmp.html_safe
		else
			return ""
		end
	end




end
