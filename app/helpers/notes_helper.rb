module NotesHelper

	def icon_for_classification(keyword)
		case keyword
		when "achat"
			ret = image_tag("achat.png").html_safe
		when "ligature"
			ret = image_tag("ligature.png").html_safe
		when "rempotage"
			ret = image_tag("rempotage.png").html_safe
		when "racines"
			ret = image_tag("racines.png").html_safe
		when "structure"
			ret = image_tag("structure.png").html_safe
		when "densification"
			ret = image_tag("densification.png").html_safe
		else
			ret = keyword.to_s.capitalize
		end
		return ret
	end
end
