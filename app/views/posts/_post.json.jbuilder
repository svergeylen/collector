json.element do 
	json.type "post"
	json.id post.id
	
	voters = []
	post.votes_for.each do |vote|
		voters << { updated_at: vote.updated_at.strftime("%d/%m"), voter_id: vote.voter_id, voter_name: User.find(vote.voter_id).name }
	end
	json.voters voters
	json.up_votes voters.count

	if current_user.voted_for?(post)
		json.up_voted true
		json.title "Vous appréciez"
	else
		json.up_voted false
		json.title "Cliquez pour apprécier"
	end
	json.route upvote_post_path(post.id, format: "json")
end