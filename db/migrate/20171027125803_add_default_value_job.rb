class AddDefaultValueJob < ActiveRecord::Migration[5.1]
  def change
  	change_column :jobs, :done, :boolean, :default => false
  end
end
