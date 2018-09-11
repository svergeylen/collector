class AddTagFiltrable < ActiveRecord::Migration[5.1]
  def change
  	add_column :tags, :filter_items, :boolean, default: :true
  end
end
