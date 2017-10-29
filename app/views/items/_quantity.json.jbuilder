json.item do 
	json.id item.id
	
	# Quantité possédée par l'utilisateur courant
	json.quantity item.quantity_for(current_user.id)

	# Possession des items par les autres utilisateurs
	json.owners do
		json.array! item.itemusers.includes(:user).where("quantity > ?", 0) do |iu|
			json.user_id iu.user_id
			json.quantity iu.quantity
			json.name iu.user.name
		end
	end

	# Route pour cliquer sur plus ou moins
	json.route quantity_item_path(item.id, format: "json")
end