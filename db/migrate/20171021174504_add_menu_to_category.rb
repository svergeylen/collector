class AddMenuToCategory < ActiveRecord::Migration[5.1]
  def change
  	add_column :categories, :menu, :boolean
  end
end
