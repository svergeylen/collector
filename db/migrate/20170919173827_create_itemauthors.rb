class CreateItemauthors < ActiveRecord::Migration[5.1]
  def change
    create_table :itemauthors do |t|
      t.belongs_to :author, foreign_key: true
      t.belongs_to :item, foreign_key: true

      t.timestamps
    end
  end
end
