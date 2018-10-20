class AddFavouritesTagsToUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :favourites do |t|
      t.belongs_to :user, index: true
      t.belongs_to :tag, index: true
      t.integer :weight, default: 0
    end

    # Ajout d'un favoris à chaque user pour démarrer
    bd = Tag.find_by(name: "Bandes dessinées")
    User.all.each do |user|
    	Favourite.create(user_id: user.id, tag_id: bd.id)
    end
  
  end
end
