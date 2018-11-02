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
end
