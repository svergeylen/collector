class AddMemoryToJobs < ActiveRecord::Migration[5.1]
  def change
  	add_column :jobs, :memory, :string 
  end
end
