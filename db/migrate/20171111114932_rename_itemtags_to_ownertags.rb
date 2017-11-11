class RenameItemtagsToOwnertags < ActiveRecord::Migration[5.1]
  def change
    # Polymorphic association:
    # "Tag can belong to an Item or another Tag (as owner)"
    rename_table  :items_tags, :ownertags
    add_column    :ownertags, :owner_type, :string,  default: "Item"
    rename_column :ownertags, :item_id,   :owner_id
  end
end
