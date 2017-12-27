class ExtendPreviewUrl < ActiveRecord::Migration[5.1]
  def change
  	change_column :posts, :preview_url, :text
  end
end
