class Polymorphic2 < ActiveRecord::Migration[5.1]
  def change
  	add_column :jobs, :element_type, :string
  end
end
