class CallbacksController < Devise::OmniauthCallbacksController


  def facebook
        #get facebook access_token
        fb_response = request.env["omniauth.auth"]
        fb_token = fb_response["credentials"]["token"]
        #create identity and initialize Koala contant with it
        identity = current_user.identities.create(facebook_categorize(fb_response))

        for_user = identity.fb_authorize(fb_token)
        #get the last six month's fbposts
        posts = get_posts(for_user)

        call = Typhoeus::Request.new(
          "bpop-api.herokuapp.com/is-complete-to-false/" + current_user.bpoptoken
        ).run

        PostsFacebook.perform_async(posts, fb_token, current_user.bpoptoken, identity[:name], session[:facebook])
        session[:facebook] = 'loggedin'

  			redirect_to '/users/sign_in#/success'
  end


  def twitter
			identity = current_user.identities.create(twitter_categorize(request.env["omniauth.auth"]))
			session[:twitter] = 'loggedin'
      redirect_to '/users/sign_in#/success'
  end

  def remove_social
  	identity = current_user.identities.where(provider: params[:provider])
  	session[identity.first.provider] = nil
  	identity.destroy_all
  	redirect_to :back
  end


  private


  def get_posts(for_user)
    since_this_date = Chronic.parse("six months ago").to_s[0..9]
    for_user.get_object('me/feed?fields=story,message,id,full_picture,link,created_time,likes{name,pic_large},comments{message,from},from&limit=5000&since=' + since_this_date)
  end


  def facebook_categorize(fb_auth)
  	return {
  		provider: fb_auth.provider,
      name: fb_auth.info.name,
      image_url: fb_auth.info.image,
      profile_url: 'https://www.facebook.com/' + fb_auth.uid,
      access_token: fb_auth.credentials["token"]
    }
  end


  def twitter_categorize(auth)
    auth.info.image.slice!('_normal')
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
