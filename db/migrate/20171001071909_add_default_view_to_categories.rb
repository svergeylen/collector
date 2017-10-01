class AddDefaultViewToCategories < ActiveRecord::Migration[5.1]
  def change
  	add_column :categories, :default_view, :string
  end
end
