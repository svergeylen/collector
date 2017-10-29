json.item do 
	json.id item.id
	
	json.quantity item.quantity_for(current_user.id)

	json.route quantity_item_path(item.id, format: "json")
end