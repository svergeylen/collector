module ItemsHelper

	#Renvoie un lien vers un item (précédent ou suivant)
	def get_link(id, direction, title)
		button_text = ('<span class="glyphicon glyphicon-arrow-'+direction+'"></span>').html_safe
		if id.present?
			ret = link_to(button_text, item_path(id), type:"button", class:"btn btn-default btn-sm", title:title)
		else
			ret = link_to(button_text, '#', type:"button", class:"btn btn-default btn-sm disabled")
		end
	end
end
