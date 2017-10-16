class AddOptionToCategory < ActiveRecord::Migration[5.1]
  def change
  	add_column :categories, :view_alphabet, :boolean
  end
end
