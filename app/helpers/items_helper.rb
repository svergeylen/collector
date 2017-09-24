module ItemsHelper


	# Renvoie un lien contenant le nombre d'étoiles de la note et pouvant ouvrir la fenetre modale d'appréciation 
	# (#avis : note + remarque par utilisateur)
	def link_to_modal(item, user_id)
		if item.like_from(current_user.id).present? and item.like_from(current_user.id).note.present?
			note = item.like_from(current_user.id).note
			link_text = note_to_s(note)
			title_text = "Note : #{note.to_s} / 5"
		else
			link_text = "Noter"
			title_text = "Pas de note"
		end

		ret = link_to link_text.html_safe, "#", {	
			class: "with_modal_window", 
			title: title_text,
			data: { 
				item_id: item.id, 
				item_title: item.name, 
				item_note: item.like_from(current_user.id).note, 
				item_remark: item.like_from(current_user.id).remark 		
			} 
		}
	return ret.html_safe
	end


	# Renvoie le nombre d'étoiles pour une note en FixNum
	def note_to_s(note)
		note = [0, note].max
		note = [note, 5].min
		link_text = ""
		for counter in 1..note
			link_text += "<span class='glyphicon glyphicon-star'></span>"
		end
		return link_text.html_safe
	end

end
