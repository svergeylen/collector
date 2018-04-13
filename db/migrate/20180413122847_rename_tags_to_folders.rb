class RenameTagsToFolders < ActiveRecord::Migration[5.1]
  def change
  	rename_table :tags, :folders
  	rename_column :folders, :root_tag, :root_folder
  	rename_table :ownertags, :ownerfolders
  	rename_column :ownerfolders, :tag_id, :folder_id
  	rename_table :items_tags, :items_folders
  	rename_column :items_folders, :tag_id, :folder_id
  end
end
