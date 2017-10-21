Rails.application.routes.draw do

	devise_for :users 
	resources :users, only: [:show] do
		member do
			get 'delete_profile_picture', as: "delete_profile_picture"
		end
	end
	


	# Blog
	resources :posts do
		member do
			get 'delete_attachment/:attachment_id', to: "posts#delete_attachment", as: "delete_attachment"
		end
	end
	resources :comments
	


	# Collector
	get 'welcome/index'
	get 'search/search'
	resources :categories
	resources :series
	resources :items do
		member do
			post :upvote
			get :plus
			get :minus
			get 'delete_attachment/:attachment_id', to: "items#delete_attachment", as: "delete_attachment"
		end
	end
	resources :authors
	


	root 'posts#index'

end
