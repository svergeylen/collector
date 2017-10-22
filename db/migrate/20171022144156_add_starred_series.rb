class AddStarredSeries < ActiveRecord::Migration[5.1]
  def change
    create_table :series_users, id: false do |t|
      t.belongs_to :users, index: true
      t.belongs_to :series, index: true
    end

  end
end
