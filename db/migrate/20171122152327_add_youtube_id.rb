class AddYoutubeId < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :youtube_id, :string
  end
end
