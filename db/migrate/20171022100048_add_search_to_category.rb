class AddSearchToCategory < ActiveRecord::Migration[5.1]
  def change
  	add_column :categories, :search, :boolean
  end
end
