class AddKeywordToCategories < ActiveRecord::Migration[5.1]
  def change
  	remove_column :categories, :menu
  	add_column :categories, :tag_name, :string, default: "Mots-clés"
  end
end
