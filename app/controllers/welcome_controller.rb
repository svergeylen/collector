class WelcomeController < ApplicationController

	# Page d'accueil de l'utilisateur aprè login
  def index
		@categories = Category.all.order(:name)
		@latest_items = Item.order(created_at: :desc).limit(20)
		set_session_category(nil)
  end

end
