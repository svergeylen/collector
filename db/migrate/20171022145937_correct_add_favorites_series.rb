class CorrectAddFavoritesSeries < ActiveRecord::Migration[5.1]
  def change
  	rename_column :series_users, :users_id, :user_id
  end
end
