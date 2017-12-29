class AddOptionsToTags < ActiveRecord::Migration[5.1]
  def change
  		add_column :tags, :fixture, :boolean, default: false
  		add_column :tags, :optional, :boolean, default: false
  		add_column :items, :rails_view, :integer, default: 0
  end
end
