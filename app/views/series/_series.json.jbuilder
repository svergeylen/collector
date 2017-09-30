json.extract! series, :id, :name, :category_id, :created_at, :updated_at


# Liste des éléments de la série
json.items do
	json.array! @series.items do |item|
		json.partial! "items/item", item: item
	end	
end

# URL pour la création des liens dans la vue
json.path series_url(series, format: :json)
json.edit_path edit_series_path(@series)
json.delete_path series_path(@series)

