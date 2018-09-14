class AdaptDatabaseForImportOldSite < ActiveRecord::Migration[5.1]
  def change
  	add_column :tags, :category_id, :integer
  end
end
