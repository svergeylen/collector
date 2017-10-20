class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string  :name
      t.references :element, polymorphic: true, index: true
      t.integer :user_id
      t.timestamps
    end

  end
end
