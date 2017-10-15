class AddCommentDateInPosts < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :last_commented_at, :datetime
  	remove_column :authors, :created_at
  	remove_column :authors, :updated_at
  	remove_column :categories, :created_at
  	remove_column :categories, :updated_at
  	remove_column :itemauthors, :created_at
  	remove_column :itemauthors, :updated_at
  	
  end
end
