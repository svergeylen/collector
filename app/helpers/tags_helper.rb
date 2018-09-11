module TagsHelper

	# Réalise le rendu d'un seul tag vers HTML, contenant le lien vers le tag et vers la suppression des tags actifs
	def render_tag(tag) 
		ret = "<span class='tag "
		if tag.filter_items? 
			ret += 'tag-filter' 
		else
			ret += 'tag-nofilter'
		end
		ret += " '>"
		ret += link_to(tag.name, tag)
		ret += " "
		ret += link_to (fa_icon 'times').html_safe, remove_tag_path(id: tag.id, remove_id: tag.id)
		ret += "</span>"
		return ret.html_safe
	end

	# Renvoie un clearfix en fonction de la résolution d'écran
	# Ceci permet que des image de tailles différentes prestent bien en grille
	# http://michaelsoriano.com/create-a-responsive-photo-gallery-with-bootstrap-framework/
	def clear_fix(i)
		cla = ""
		j = i + 1
		if (j % 2 == 0)
			cla += "visible-xs-block "
		end
		if (j % 3 == 0)
			cla += "visible-sm-block "
		end
		if (j % 4 == 0)
			cla += "visible-md-block "
		end
		if (j % 6 == 0)
			cla += "visible-lg-block "
		end
		if cla != ""
			return "<div class='clearfix #{cla}'></div>".html_safe
		else
			return ""
		end
	end


end
