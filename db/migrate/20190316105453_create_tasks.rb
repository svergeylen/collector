class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.text :message
      t.string :classification
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
