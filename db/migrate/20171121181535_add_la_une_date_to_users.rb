class AddLaUneDateToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :displayed_la_une, :datetime
  end
end
