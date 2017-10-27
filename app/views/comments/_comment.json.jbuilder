json.element do
	json.type "comment"
	json.id comment.id
	
	voters = comment.votes_for.includes(:voter).map do |vote|
	    { updated_at: vote.updated_at.strftime("%d/%m/%y"), voter_id: vote.voter_id, voter_name: vote.voter.name }
	end
	json.voters voters
	json.up_votes voters.count

	if current_user.voted_for?(comment)
		json.up_voted true
		json.title "Vous appréciez"
	else
		json.up_voted false
		json.title "Cliquez pour apprécier"
	end
	json.route upvote_comment_path(comment.id, format: "json")
end