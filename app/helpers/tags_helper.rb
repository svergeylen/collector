module TagsHelper

	# Fait le rendu pcomplet des breadcrumb pour un tag donné
	def breadcrumbs_for(tag)
		tmp = tag.parent_tags.collect { |t| one_breadcrumb(t) }
		tmp << one_breadcrumb(tag)
		return tmp.join(" > ").html_safe
	end

	# Fait le rendu d'un seul élément de breadcrumb
	def one_breadcrumb(tag)
		return (link_to tag.name, tag)
	end
end
