class RenameEarch < ActiveRecord::Migration[5.1]
  def change
  	rename_column :categories, :search, :view_search
  end
end
