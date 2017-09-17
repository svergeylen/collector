class WelcomeController < ApplicationController

	# Page d'accueil de l'utilisateur aprè login
  def index
		@categories = Category.all.order(:name)
		@items = Item.order(created_at: :desc).limit(10)
  end

end
