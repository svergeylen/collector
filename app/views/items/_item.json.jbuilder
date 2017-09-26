json.extract! item, :id, :numero, :name, :series_id, :created_at, :updated_at

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
# json.url item_url(item, format: :json)
