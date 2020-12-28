Rails.application.routes.draw do

  resources :folders
  # Attachment
  get "attachment/:attachment_id/:style.:extension", to: "attachments#download", as: "download_attachment"

	# Accueil
	get 'welcome/index'

	# Users
	devise_for :users, controllers: {
    	sessions: 'users/sessions',
    	registrations: 'users/registrations'
	}
	resources :users, only: [:show] do
		member do
			get 'delete_profile_picture', as: "delete_profile_picture"
		end
	end

	# La Une
	resources :posts do
		member do
			get 'upvote'
			get 'delete_attachment/:attachment_id', to: "posts#delete_attachment", as: "delete_attachment"
			get 'remove_preview'
		end
	end
	post 'posts/preview'
	resources :comments

	# Collector
	get 'welcome/collector'
	get 'search/keyword'	# recherche globale (haut à droite)
	resources :tags do
		post 'actions', on: :collection	# formulaire d'actions en bas de page de tags#index
		member do
			get 'remove/:remove_id', to: 'tags#remove', as: 'remove'
		end
	end

	resources :items do
		resources :notes
		post 'actions', on: :collection	# formulaire de modification de plusieurs items en bas de tag#show
		member do
			post 'quantity'
			get  'delete_attachment/:attachment_id', to: "items#delete_attachment", as: "delete_attachment"
			get  'enhance'
		end
	end
	post 'items/actions'
	

	# Cron /!\ Pas d'authentification
	get 'cron/jobs'
	get 'cron/run'

	# Page d'accueil
	root 'welcome#index'

end
