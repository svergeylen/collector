class AddAncestryToFolders < ActiveRecord::Migration[5.1]
  def change
    add_column :folders, :ancestry, :string
    add_index :folders, :ancestry
  end
end
