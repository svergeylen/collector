class Simplif < ActiveRecord::Migration[5.1]
  def change
  	#remove_column :tags, :root_tag
  	#remove_column :tags, :default_view
  	#remove_column :tags, :letter
  	#remove_column :tags, :filter_items
  	#drop_table :favourites
  	#Ownertag.where(owner_type: "Tag").delete_all
  	remove_column :ownertags, :owner_type
  	remove_column :ownertags, :id
  	rename_column :ownertags, :owner_id, :item_id
  	rename_table :ownertags, :items_tags

  end
end
