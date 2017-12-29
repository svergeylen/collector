class AddRootTag < ActiveRecord::Migration[5.1]
  def change
  	add_column :tags, :root_tag, :boolean, default: false
  	remove_columns :tags, :category_id
  end
end
