Rails.application.routes.draw do

  

	# Users
	devise_for :users, controllers: {
    	sessions: 'users/sessions',
    	registrations: 'users/registrations'
	}
	resources :users, only: [:show] do
		member do
			get 'delete_profile_picture', as: "delete_profile_picture"
			get :favorites
		end
	end
	


	# La Une
	resources :posts do
		member do
			post :upvote
			get 'delete_attachment/:attachment_id', to: "posts#delete_attachment", as: "delete_attachment"
			get :remove_preview
		end
	end
	post 'posts/preview'
	resources :comments do
		member do
			post :upvote
		end
	end
	


	# Collector
	get 'welcome/index'
	get 'search/keyword'
	resources :categories
	resources :series do
		member do
			get :star
		end
	end
	resources :items do
		member do
			post :upvote
			post :quantity
			get 'delete_attachment/:attachment_id', to: "items#delete_attachment", as: "delete_attachment"
		end
	end
	resources :tags
	
	# Cron /!\ Pas d'authentification
	get 'cron/jobs'
	get 'cron/run'

	# Page d'accueil /!\ Pas d'authentification
	root 'welcome#index'

end
