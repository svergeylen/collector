class AddImageUrlToPosts < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :preview_image_url, :string
  end
end
