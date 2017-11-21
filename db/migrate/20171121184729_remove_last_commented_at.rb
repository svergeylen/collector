class RemoveLastCommentedAt < ActiveRecord::Migration[5.1]
  def change
  	remove_column :posts, :last_commented_at
  end
end
