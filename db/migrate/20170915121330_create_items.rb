class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :numero
      t.string :name
      t.integer :series_id

      t.timestamps
    end
  end
end
