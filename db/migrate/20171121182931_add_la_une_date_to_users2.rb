class AddLaUneDateToUsers2 < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :last_displayed_la_une, :datetime
  end
end
