class UrlPostImage < ActiveRecord::Migration[5.1]
  def change
  	change_column :posts, :preview_image_url, :text
  end
end
