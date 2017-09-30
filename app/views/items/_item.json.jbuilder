json.extract! item, :id, :numero, :name, :series_id, :created_at, :updated_at

# Liste des auteurs de l'item
json.authors item.authors do |author|
  json.author_id author.id
  json.name author.name
  json.show_path author_path(author.id)
end


# Nombre de votes sur l'item actuellement. Utilisation du gem Acts_as_votable
json.up_votes item.votes_for.count

# données de l'utilisateur qui a voté
#json.user do 
#	json.extract! item.user, :email
#1end

# Si l'utilisateur est loggé, on regarde s'il a déjà voté sur l'élément
if user_signed_in?
	json.up_voted current_user.voted_for? item
end

# ajouté par le scaffold. pas touché...
json.show_path item_path(item)
