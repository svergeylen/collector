class AddCateAndSeriesOptionsToTags < ActiveRecord::Migration[5.1]
  def change
  	add_column :tags, :default_view, :string
  	add_column :tags, :letter, :string
  end
end
