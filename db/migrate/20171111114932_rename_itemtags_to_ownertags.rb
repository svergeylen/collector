class RenameItemtagsToOwnertags < ActiveRecord::Migration[5.1]
  def change
    # Polymorphic association:
    # "Tag can belong to an Item or another Tag (as owner)"
    rename_table  :items_tags, :ownertags
    add_column    :ownertags, :owner_type, :string,  default: "Item"
    rename_column :ownertags, :item_id,   :owner_id

    # Rails needs a primary key to delete associated records, see:
    # https://github.com/rails/rails/issues/20755
    add_column   :ownertags, :id, :primary_key
  end
end
