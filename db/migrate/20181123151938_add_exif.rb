class AddExif < ActiveRecord::Migration[5.1]
  def change
  	add_column :attachments, :exif, :text
  end
end
