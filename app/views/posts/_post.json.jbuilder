json.element do
	json.type "post"
	json.id post.id
	json.up_votes post.votes_for.count
	json.up_voted current_user.voted_for?(post)
	json.route upvote_post_path(post.id, format: "json")
end