class SearchController < ApplicationController

	# recherche le terme donnée dans les séries et items
  def keyword
	@keyword = params[:keyword] if params[:keyword].present?
	
	@folders = Folder.search(@keyword).limit(50)
	@items = Item.search(@keyword).limit(50)

	 respond_to do |format|
        format.html
     end
  end

end
