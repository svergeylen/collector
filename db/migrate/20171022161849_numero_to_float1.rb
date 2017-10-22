class NumeroToFloat1 < ActiveRecord::Migration[5.1]
  def change
  	add_column :items, :number, :float
  end
end
