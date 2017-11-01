class AddBasicAccessRights < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :rights, :integer, default: 0
  end
end
