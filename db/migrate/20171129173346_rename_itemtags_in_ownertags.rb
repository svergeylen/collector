class RenameItemtagsInOwnertags < ActiveRecord::Migration[5.1]
  def change

   # Polymorphic association:
   # "Tag can belongs to an Item or another Tag (as owner)"
   rename_table  :items_tags, :ownertags
   add_column    :ownertags, :owner_type, :string,  default: "Item"
   rename_column :ownertags, :item_id,   :owne
   add_column    :ownertags, :id, :primary_key

  end
end
