class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
  	unless session[:facebook]
			identity = current_user.identities.create(facebook_categorize(request.env["omniauth.auth"]))
			session[:facebook] = 'loggedin'
			new_user_identity_fbpost_path(current_user.id, identity.id)
		end
    redirect_to root_path
  end

  def twitter
  	unless session[:twitter]
			current_user.identities.create(twitter_categorize(request.env["omniauth.auth"]))
			session[:twitter] = 'loggedin'
		end
    redirect_to root_path
  end

  def remove_social
  	identity = current_user.identities.find_by_id(params[:identityId])
  	session[identity.provider] = nil
  	identity.destroy
  	redirect_to root_path
  end


  private

  def facebook_categorize(auth)
  	return {
  		provider: auth.provider,
      name: auth.info.name,
      image_url: auth.info.image,
      profile_url: auth.info.urls.Facebook,
      access_token: auth.credentials["token"]
    } 
  end

  def twitter_categorize(auth)
  	return {
  		provider: auth.provider,
      name: auth.info.nickname,
      image_url: auth.info.image,
      followers_count: auth.extra.raw_info.followers_count,
      friends_count: auth.extra.raw_info.friends_count,
      statuses_count: auth.extra.raw_info.statuses_count,
      profile_url: auth.info.urls.Twitter,
      access_token: auth.extra.access_token.consumer.key,
      secret_token: auth.extra.access_token.consumer.secret 
    }
  end
end
