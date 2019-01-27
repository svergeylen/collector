class AddEnhanceToItems < ActiveRecord::Migration[5.1]
  def change
  	add_column :items, :enhanced_image, :text
  	add_column :items, :enhanced_content, :text
  end
end
