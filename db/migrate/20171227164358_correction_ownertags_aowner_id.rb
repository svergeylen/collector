class CorrectionOwnertagsAownerId < ActiveRecord::Migration[5.1]
  def change
  	rename_column :ownertags, :owne, :owner_id
  end
end
