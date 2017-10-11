class ChangeAddedBy < ActiveRecord::Migration[5.1]
  def change
  	rename_column :items, "added_by", "adder_id"
  end
end
