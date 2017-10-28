class AddDesc < ActiveRecord::Migration[5.1]
  def change
  	add_column :items, :description, :text
  end
end
