json.element do
	json.type "comment"
	json.id comment.id
	json.up_votes comment.votes_for.count
	json.up_voted current_user.voted_for?(comment)
	json.route upvote_comment_path(comment.id, format: "json")
end