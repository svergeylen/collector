class AddFolderToItems < ActiveRecord::Migration[5.1]
  def change
  	add_reference :items, :folder, foreign_key: true
  end
end
