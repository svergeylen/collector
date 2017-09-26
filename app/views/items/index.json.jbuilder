json.items do
	json.array! @items do |item|
		json.partial! "items/item", item: item
	end	
end

