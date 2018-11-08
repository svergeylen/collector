module PostsHelper

	def render_votes_title(votes)
		ret = "<ul>"
		votes.each do |vote| 
		 	ret+= "<li>"+vote.voter.name+" : "
		 	ret+= "<strong>"+vote.vote_weight.to_s+ "</strong> "+ image_tag("applause.svg", height:"17" )
		 	ret+= " ("+ short_date(vote.updated_at) + ")</li>"
		end
		ret+="</ul>"
		ret+="</div>"

		return sanitize(ret)
	end

	# Renvoie "active" lorsque le slide du carousel soit être actif (params_id si donné ou le slide 0 sinon)
	def active(i, params_id)
		if params_id.blank?
			if i.to_i.zero?
				return 'active'
			else
				return ''
			end
		else
			if (i.to_i==params_id.to_i)
				return 'active'
			else
				return ''
			end
		end
	end
end
