json.element do 
	json.type "item"
	json.id item.id
	
	voters = item.votes_for.includes(:voter).map do |vote|
	    { updated_at: vote.updated_at.strftime("%d/%m/%y"), voter_id: vote.voter_id, voter_name: vote.voter.name }
	end
	json.voters voters
	json.up_votes voters.count

	if current_user.voted_for?(item)
		json.up_voted true
		json.title "Vous appréciez"
	else
		json.up_voted false
		json.title "Cliquez pour apprécier"
	end
	json.route upvote_item_path(item.id, format: "json")
end