Rails.application.routes.draw do

	get 'welcome/index'

	devise_for :users

	get 'search/search'

	resources :categories
	resources :series
	resources :items do
		member do
			post :upvote
		end
	end
	post 'items/like'
	resources :authors
	

	root 'welcome#index'

end
