class RemoveNumeroFromItems < ActiveRecord::Migration[5.1]
  def change
  	remove_column :items, :numero
  end
end
