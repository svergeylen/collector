class SearchController < ApplicationController

	# Recherche le terme donnée dans les tous les objets du site
  def keyword
  	@keyword = params[:keyword] if params[:keyword].present?
  	
  	@tags = Tag.search(@keyword).limit(50)
  	@items = Item.search(@keyword).limit(50)
    @posts = Post.search(@keyword)
    @comments = Comment.search(@keyword)

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
