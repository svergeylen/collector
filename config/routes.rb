Rails.application.routes.draw do


  devise_for :users

  get 'welcome/index'
  get 'search/search'

	resources :categories
	resources :series
  resources :items do
		get 'like', on: :member
	end
	resources :authors

  root 'welcome#index'

end
