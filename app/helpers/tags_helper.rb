module TagsHelper

	# Réalise le rendu d'une liste de tag
	def render_tags(tags, with_delete_option = false)
		ret = ""
		if tags.present?
			tags.each do |tag|
				ret += render_tag(tag, with_delete_option)
			end
		else
			ret += "-"
		end
		return ret.html_safe
	end

	# Réalise le rendu d'un seul tag vers HTML, contenant le lien vers le tag et vers la suppression des tags actifs
	def render_tag(tag, with_delete_option = false) 
		ret = "<span class='collector-tag "
		if tag.filter_items? 
			ret += "collector-tag-filter'>"
		else
			ret += "collector-tag-nofilter' title='Tag non-filtrant'>"
		end
		ret += link_to tag.name, tag 
		ret += "  "
		if with_delete_option
			ret += link_to (fa_icon 'times').html_safe, remove_tag_path(id: tag.id, remove_id: tag.id)
		end
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
