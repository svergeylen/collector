class RemoveLastDisplayedLaUne < ActiveRecord::Migration[5.1]
  def change
  		remove_column :users, :last_displayed_la_une
  end
end
