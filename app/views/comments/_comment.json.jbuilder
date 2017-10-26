json.element do
	json.type "comment"
	json.id comment.id
	
	voters = []
	comment.votes_for.each do |vote|
		voters << { updated_at: vote.updated_at.strftime("%d/%m"), voter_id: vote.voter_id, voter_name: User.find(vote.voter_id).name }
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