class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.string :action
      t.integer :element_id
      t.integer :user_id
      t.boolean :done

      t.timestamps
    end
  end
end
