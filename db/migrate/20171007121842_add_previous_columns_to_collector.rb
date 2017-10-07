class AddPreviousColumnsToCollector < ActiveRecord::Migration[5.1]
  def change
  	add_column :series, "letter", :string
  	add_column :items, "added_by", :integer
  end
end
