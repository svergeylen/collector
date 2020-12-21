module TagsHelper

	# Réalise le rendu d'une liste de tag
	def render_tags(tags, with_delete_option = false)
		ret = ""
		if tags.present?
			tags.each do |tag|
				ret += render_tag(tag, with_delete_option)+ " "
			end
		end
		return ret.html_safe
	end

	# Réalise le rendu d'un seul tag vers HTML, contenant le lien vers le tag et vers la suppression des tags actifs
	def render_tag(tag, with_delete_option = false) 
		return ("<span class='collector-tag collector-tag-nofilter' title='Tag non-filtrant'>"+ link_to(tag.name, tag)+"</span>").html_safe
	end



end
