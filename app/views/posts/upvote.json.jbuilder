json.extract! @post, :id

# Nombre de votes sur l'item actuellement. Utilisation du gem Acts_as_votable
json.up_votes @post.votes_for.count

# Si l'utilisateur est loggé, on regarde s'il a déjà voté sur l'élément
if user_signed_in?
	json.up_voted current_user.voted_for? @post
end

