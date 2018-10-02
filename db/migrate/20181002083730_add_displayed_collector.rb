class AddDisplayedCollector < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :displayed_collector, :datetime
  end
end
