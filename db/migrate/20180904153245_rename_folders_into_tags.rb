class RenameFoldersIntoTags < ActiveRecord::Migration[5.1]
  def change
  	rename_table :items_folders, :items_tags
  	rename_table :ownerfolders, :ownertags
  	rename_column :items_tags, :folder_id, :tag_id
  	rename_column :ownertags, :folder_id, :tag_id
  end
end
