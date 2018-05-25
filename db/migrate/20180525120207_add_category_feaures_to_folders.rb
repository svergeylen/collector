class AddCategoryFeauresToFolders < ActiveRecord::Migration[5.1]
  def change
		add_column :folders, :view_alphabet, :boolean, default: false
  end
end
