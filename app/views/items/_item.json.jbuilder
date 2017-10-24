json.element do
	json.type "item"
	json.id item.id
	json.up_votes item.votes_for.count
	json.up_voted current_user.voted_for?(item)
	json.route upvote_item_path(item.id, format: "json")
end