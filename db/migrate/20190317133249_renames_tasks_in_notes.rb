class RenamesTasksInNotes < ActiveRecord::Migration[5.1]
  def change
  	rename_table :tasks, :notes
  end
end
