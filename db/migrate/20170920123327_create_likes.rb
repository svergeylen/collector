class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.belongs_to :item, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :note
      t.string :remark

      t.timestamps
    end
  end
end
