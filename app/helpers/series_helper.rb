module SeriesHelper

	# Renvoie un lien pour ouvrir la fenetre modale d'appréciation (#avis : note + remarque par utilisateur)
	def link_to_modal(item, user_id)
		text = item.like_from(user_id).remark || "Ajouter"
		link_to (truncate( text, length: 60, separator: ' ') ) , "#", {	
			class: "with_modal_window", 
			title: text,
			data: { 
				item_id: item.id, 
				item_title: item.name, 
				item_note: item.like_from(current_user.id).note, 
				item_remark: item.like_from(current_user.id).remark 		
			} 
		}	
	end

end
