Rails.application.routes.draw do

 root 'home#index'
 get '/check', to: 'home#check'
 get '/check', to: 'home#check'
 get '/log_out', to: 'users/sessions#destroy'


 get '/search-fan', to: 'home#search_byfan'
 get '/get-group-posts', to: 'home#group_posts'
 get '/get-single_fan_posts', to: 'home#single_fan'
 get '/get-carousel-numbers', to: 'home#get_carousel_numbers'
 get '/get-6-month-data', to: 'home#get_6_month_data'
 get '/get-gender-percentage', to: 'home#get_gender_percentage'

 devise_for :users, :controllers => {
   sessions: 'users/sessions',
   passwords: 'users/passwords',
   registrations: 'users/registrations',
   omniauth_callbacks: 'callbacks'
 }

  devise_scope :user do
    get 'users/:user_id/remove_social', to: 'callbacks#remove_social', as: 'remove_social'
    get 'users/:user_id/facebook/update', to: 'callbacks#facebook_update', as: 'facebook_update'
  end

	resources :users 			do
	  resources :identities do
	  	end
	  end
	end
