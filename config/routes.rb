Rails.application.routes.draw do

 root 'home#index'
 get '/search-fan', to: 'home#search_byfan'

 devise_for :users, :controllers => { sessions: 'users/sessions', :omniauth_callbacks => 'callbacks' }


  devise_scope :user do
    get 'users/:user_id/remove_social', to: 'callbacks#remove_social', as: 'remove_social'
    get 'users/:user_id/facebook/update', to: 'callbacks#facebook_update', as: 'facebook_update'
  end

	resources :users 			do
	  resources :identities do
	  	resources :fbposts 		do
	  		resources :fblikes
	  		end
	  	end
	  end
	end

#                          Prefix Verb     URI Pattern                                                                           Controller#Action
#                             root GET      /                                                                                     home#index
#                 new_user_session GET      /users/sign_in(.:format)                                                              devise/sessions#new
#                     user_session POST     /users/sign_in(.:format)                                                              devise/sessions#create
#             destroy_user_session DELETE   /users/sign_out(.:format)                                                             devise/sessions#destroy
#          user_omniauth_authorize GET|POST /users/auth/:provider(.:format)                                                       callbacks#passthru {:provider=>/facebook|twitter/}
#           user_omniauth_callback GET|POST /users/auth/:action/callback(.:format)                                                callbacks#(?-mix:facebook|twitter)
#                    user_password POST     /users/password(.:format)                                                             devise/passwords#create
#                new_user_password GET      /users/password/new(.:format)                                                         devise/passwords#new
#               edit_user_password GET      /users/password/edit(.:format)                                                        devise/passwords#edit
#                                  PATCH    /users/password(.:format)                                                             devise/passwords#update
#                                  PUT      /users/password(.:format)                                                             devise/passwords#update
#         cancel_user_registration GET      /users/cancel(.:format)                                                               devise/registrations#cancel
#                user_registration POST     /users(.:format)                                                                      devise/registrations#create
#            new_user_registration GET      /users/sign_up(.:format)                                                              devise/registrations#new
#           edit_user_registration GET      /users/edit(.:format)                                                                 devise/registrations#edit
#                                  PATCH    /users(.:format)                                                                      devise/registrations#update
#                                  PUT      /users(.:format)                                                                      devise/registrations#update
#                                  DELETE   /users(.:format)                                                                      devise/registrations#destroy
#                    remove_social GET      /users/:user_id/remove_social(.:format)                                               callbacks#remove_social
#     user_identity_fbpost_fblikes GET      /users/:user_id/identities/:identity_id/fbposts/:fbpost_id/fblikes(.:format)          fblikes#index
#                                  POST     /users/:user_id/identities/:identity_id/fbposts/:fbpost_id/fblikes(.:format)          fblikes#create
#  new_user_identity_fbpost_fblike GET      /users/:user_id/identities/:identity_id/fbposts/:fbpost_id/fblikes/new(.:format)      fblikes#new
# edit_user_identity_fbpost_fblike GET      /users/:user_id/identities/:identity_id/fbposts/:fbpost_id/fblikes/:id/edit(.:format) fblikes#edit
#      user_identity_fbpost_fblike GET      /users/:user_id/identities/:identity_id/fbposts/:fbpost_id/fblikes/:id(.:format)      fblikes#show
#                                  PATCH    /users/:user_id/identities/:identity_id/fbposts/:fbpost_id/fblikes/:id(.:format)      fblikes#update
#                                  PUT      /users/:user_id/identities/:identity_id/fbposts/:fbpost_id/fblikes/:id(.:format)      fblikes#update
#                                  DELETE   /users/:user_id/identities/:identity_id/fbposts/:fbpost_id/fblikes/:id(.:format)      fblikes#destroy
#            user_identity_fbposts GET      /users/:user_id/identities/:identity_id/fbposts(.:format)                             fbposts#index
#                                  POST     /users/:user_id/identities/:identity_id/fbposts(.:format)                             fbposts#create
#         new_user_identity_fbpost GET      /users/:user_id/identities/:identity_id/fbposts/new(.:format)                         fbposts#new
#        edit_user_identity_fbpost GET      /users/:user_id/identities/:identity_id/fbposts/:id/edit(.:format)                    fbposts#edit
#             user_identity_fbpost GET      /users/:user_id/identities/:identity_id/fbposts/:id(.:format)                         fbposts#show
#                                  PATCH    /users/:user_id/identities/:identity_id/fbposts/:id(.:format)                         fbposts#update
#                                  PUT      /users/:user_id/identities/:identity_id/fbposts/:id(.:format)                         fbposts#update
#                                  DELETE   /users/:user_id/identities/:identity_id/fbposts/:id(.:format)                         fbposts#destroy
#                  user_identities GET      /users/:user_id/identities(.:format)                                                  identities#index
#                                  POST     /users/:user_id/identities(.:format)                                                  identities#create
#                new_user_identity GET      /users/:user_id/identities/new(.:format)                                              identities#new
#               edit_user_identity GET      /users/:user_id/identities/:id/edit(.:format)                                         identities#edit
#                    user_identity GET      /users/:user_id/identities/:id(.:format)                                              identities#show
#                                  PATCH    /users/:user_id/identities/:id(.:format)                                              identities#update
#                                  PUT      /users/:user_id/identities/:id(.:format)                                              identities#update
#                                  DELETE   /users/:user_id/identities/:id(.:format)                                              identities#destroy
#                            users GET      /users(.:format)                                                                      users#index
#                                  POST     /users(.:format)                                                                      users#create
#                         new_user GET      /users/new(.:format)                                                                  users#new
#                        edit_user GET      /users/:id/edit(.:format)                                                             users#edit
#                             user GET      /users/:id(.:format)                                                                  users#show
#                                  PATCH    /users/:id(.:format)                                                                  users#update
#                                  PUT      /users/:id(.:format)                                                                  users#update
#                                  DELETE   /users/:id(.:format)                                                                  users#destroy
