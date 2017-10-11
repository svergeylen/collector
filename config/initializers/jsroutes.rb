

JsRoutes.setup do |config|
	# Nouvelle route : 	rake tmp:cache:clear
	# 					rail s
	config.include = [
		/^upvote_item$/,
		/^edit_item$/,
		/^destroy_item$/
	]

end
