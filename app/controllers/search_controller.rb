class SearchController < ApplicationController

	# Recherche le terme donnée dans les tous les objets du site
  def keyword
  	@keyword = params[:keyword] if params[:keyword].present?
  	
  	@folders = Folder.search(@keyword).limit(50)
  	@items = Item.search(@keyword).limit(50)
    @posts = Post.search(@keyword)
    @comments = Comment.search(@keyword)

  	respond_to do |format|
      format.html
    end
  end


end
