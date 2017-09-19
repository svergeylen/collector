class SearchController < ApplicationController

	# recherche le terme donnée dans les séries et items
  def search
		@keyword = params[:keyword]
		@series = Series.search(params[:keyword]).limit(50)

		# Poursuite de la recherche dans les items si pas de série correspondante
		#if (@series.count <= 0)
			@items = Item.search(params[:keyword]).limit(50)
		#end
	
  end
end
