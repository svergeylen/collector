Rails.application.routes.draw do


  devise_for :users

  get 'welcome/index'
  get 'search/search'

	resources :categories
	resources :series
  resources :items 
	post 'items/like'
	resources :authors

  root 'welcome#index'

end
