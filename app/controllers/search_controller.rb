class SearchController < ApplicationController

	# recherche le terme donnée dans les séries et items
  def keyword
	@keyword = params[:keyword] if params[:keyword].present?
	
	@tags = Tag.search(@keyword).limit(50)
	@items = Item.search(@keyword).limit(50)

	 respond_to do |format|
        format.html
     end
  end

  # Recherche parmi les tag et renvoie en JSON les tags qui correspondent à keyword
  def tag
	@tags = Tag.search(params[:keyword] ).limit(50) if params[:keyword].present?

	respond_to do |format|
        format.js
    end

  end

end
