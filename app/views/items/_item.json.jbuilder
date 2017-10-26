json.element do 
	json.type "item"
	json.id item.id
	
	voters = []
	item.votes_for.each do |vote|
		voters << { updated_at: vote.updated_at.strftime("%d/%m"), voter_id: vote.voter_id, voter_name: User.find(vote.voter_id).name }
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