class CreateItemusers < ActiveRecord::Migration[5.1]
  def change
    create_table :itemusers do |t|
      t.integer :item_id
      t.integer :user_id
      t.integer :quantity
      t.datetime :checked_at

      t.timestamps
    end
  end
end
