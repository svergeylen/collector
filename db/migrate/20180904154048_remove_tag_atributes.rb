class RemoveTagAtributes < ActiveRecord::Migration[5.1]
  def change
  	remove_column :tags, :fixture
  	remove_column :tags, :optional
  	remove_column :tags, :category_id
  end
end
