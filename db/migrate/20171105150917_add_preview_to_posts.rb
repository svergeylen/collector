class AddPreviewToPosts < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :preview_url, :string
  	add_column :posts, :preview_title, :string
  	add_column :posts, :preview_description, :text
  end
end
