Rails.application.routes.draw do

  
  # get 'users/show'

	devise_for :users 
	resources :users, only: [:show] do
		member do
			get 'delete_profile_picture', as: "delete_profile_picture"
		end
	end
	


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
