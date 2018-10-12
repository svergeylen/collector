class EpurationApresMigrationTags < ActiveRecord::Migration[5.1]
  def change
  	drop_table :series
  	drop_table :categories
  	drop_table :items_tags
  	drop_table :series_users

  	remove_column :items, :series_id
  	remove_column :items, :rails_view
  	remove_column :tags, :category_id
  	remove_column :tags, :view_alphabet

  	add_index :itemusers, :item_id
  	add_index :itemusers, :user_id
  	add_index :tags, :name
  	add_index :tags, :letter
  end
end
