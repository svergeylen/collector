class SearchController < ApplicationController

	# Recherche le terme donnée dans les tous les objets du site
  def keyword
  	@keyword = params[:keyword] if params[:keyword].present?
  	
  	lim = 50
  	@folders = Folder.search(@keyword).limit(lim)
  	@tags = Tag.search(@keyword).limit(lim)
  	@items = Item.search(@keyword).limit(lim)
    @posts = Post.search(@keyword)
    @comments = Comment.search(@keyword)

  	respond_to do |format|
      format.html
    end
  end


end
