class Finalisation < ActiveRecord::Migration[5.1]
  def change
  	remove_column :items_tags, :owner_type
  	remove_column :items, :item_type
		# Purge anciens votes sur items et comments (act_as_votable)
		results = ActiveRecord::Base.connection.execute("DELETE FROM votes WHERE votable_type = 'Item' ")
		results = ActiveRecord::Base.connection.execute("DELETE FROM votes WHERE votable_type = 'Comment' ")
  end
end
