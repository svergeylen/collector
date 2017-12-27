json.element do 
	json.type "post"
	json.id @post.id
	
	voters = @post.votes_for.includes(:voter).map do |vote|
	    { updated_at: vote.updated_at.strftime("%d/%m/%y"), voter_id: vote.voter_id, voter_name: vote.voter.name, vote_weight: vote.vote_weight }
	end
	json.voters voters
	json.voters_count voters.count
	json.total @post.total_upvotes

	if current_user.voted_for?(@post)
		json.up_voted true
		json.title "Vous appréciez"
	else
		json.up_voted false
		json.title "Cliquez pour apprécier"
	end
end