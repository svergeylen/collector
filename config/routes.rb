Rails.application.routes.draw do


  devise_for :users
	resources :categories
	resources :series
  resources :items


  get 'welcome/index'
  root 'welcome#index'

end
