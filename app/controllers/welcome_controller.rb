class WelcomeController < ApplicationController
  def index
		@categories = Category.all.order(:name)
		@items = Item.order(created_at: :desc).limit(10)
  end
end
