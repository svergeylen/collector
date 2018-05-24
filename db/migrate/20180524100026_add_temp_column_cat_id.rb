class AddTempColumnCatId < ActiveRecord::Migration[5.1]
  def change
	add_column :folders, :category_id, :integer
  end
end
