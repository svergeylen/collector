

JsRoutes.setup do |config|
	# Nouvelle route : 	rake tmp:cache:clear
	# 					rail s
	config.include = [
		/^upvote_item$/
	]

end
