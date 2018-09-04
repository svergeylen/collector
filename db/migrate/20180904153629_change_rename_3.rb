class ChangeRename3 < ActiveRecord::Migration[5.1]
  def change
  	rename_column :tags, :root_folder, :root_tag
  end
end
