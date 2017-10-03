Rails.application.routes.draw do

  
  get 'users/show'

	devise_for :users 
	resources :users, only: [:show]


	# Blog
	resources :posts 
	resources :comments
	


	# Collector
	get 'welcome/index'
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
	


	root 'posts#index'

end
