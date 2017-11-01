class AddScopeToTags < ActiveRecord::Migration[5.1]
  def change
  	
  	rename_table :itemauthors, :items_tags
  	rename_column :items_tags, :author_id, :tag_id
  	remove_column :items_tags, :id
  	
  	rename_table :authors, :tags
  	add_column :tags, :category_id, :integer
  end
end
