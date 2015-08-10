class CallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    #check if user has already facebook identity
    	if session[:facebook] || current_user.identities.any? { |x| x[:provider]["facebook"] }
    		redirect_to root_path
    	else
        session[:facebook] = 'loggedin'
       #get facebook access_token
        fb_response = request.env["omniauth.auth"]
        fb_token = fb_response["credentials"]["token"]
       #create identity and initialize Koala contant with it
        identity = current_user.identities.create(facebook_categorize(fb_response))
        for_user = identity.fb_authorize(fb_token)
       #get the last six month's fbposts
        posts = get_posts(for_user)
       #API call post request to bPop_api for fbposts
        post_fbposts_to_bPop_api(posts, fb_token)

  			redirect_to root_path
  		end
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

  def get_posts(for_user)
    since_this_date = Chronic.parse("six months ago").to_s[0..9]
    for_user.get_object('me/posts?limit=5000&since=' + since_this_date)
  end

  def facebook_categorize(fb_auth)
  	return {
  		provider: fb_auth.provider,
      name: fb_auth.info.name,
      image_url: fb_auth.info.image,
      profile_url: fb_auth.info.urls.Facebook,
      access_token: fb_auth.credentials["token"]
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

  def post_fbposts_to_bPop_api(posts, fb_token)
    #create likes / likes_data variables
    posts.each do |post| 
      
      if post['likes']
        likes = post['likes']['data'].length
        likes_data = post['likes']['data'].to_json
        
      else
        likes = 0
        likes_data = "0"
      end
      #define params post request
      params = {
        fbpost: {
          user_token: current_user.bpop_token,
          story: post['story'],
          message: post['message'],
          likes: likes,
          likes_data: likes_data,
          url: post['link'],
          date: post['created_time'][0..9],
          fb_user_token: fb_token
        }
      } 
      #send post request
      response = Typhoeus::Request.new(
        "http://localhost:4000/fbposts",
        method: :post,
        params: params
      ).run
    end
    
  end

end
