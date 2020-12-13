class AddLetterToFolder < ActiveRecord::Migration[5.1]
  def change
  	add_column :folders, :letter, :string
  	add_column :folders, :default_view, :string
  end
end
