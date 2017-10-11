class RemoveSiteBd < ActiveRecord::Migration[5.1]
  def change
  	drop_table :bd_auteurs
  	drop_table :bd_bd
  	drop_table :bd_bdaid
  	drop_table :bd_membres
  	drop_table :bd_prets
  	drop_table :bd_series
  	drop_table :likes
  end
end
