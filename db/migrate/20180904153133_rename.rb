class Rename < ActiveRecord::Migration[5.1]
  def change
  	rename_table :folders, :tags
  end
end
