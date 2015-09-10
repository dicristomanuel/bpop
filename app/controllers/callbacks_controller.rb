class CallbacksController < Devise::OmniauthCallbacksController

  def facebook
        #get facebook access_token
        fb_response = request.env["omniauth.auth"]
        fb_token = fb_response["credentials"]["token"]
        #create identity and initialize Koala contant with it
        identity = current_user.identities.create(facebook_categorize(fb_response))
        if identity.errors.messages[:profile_url]
          flash[:error] = 'already connected to other user'
        end
        for_user = identity.fb_authorize(fb_token)
        #get the last six month's fbposts
        posts = get_posts(for_user)
        #API call post request to bPop_api for fbposts / passing posts, tokens and owner's name
        fbposts_to_bPop_api(posts, fb_token, current_user.bpopToken, fb_response['info']['name'])

  			redirect_to :back
  end


  def twitter
  	unless session[:twitter]
			current_user.identities.create(twitter_categorize(request.env["omniauth.auth"]))
			session[:twitter] = 'loggedin'
		end
    redirect_to 'http://localhost:3000/users/sign_in#/success'
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


  def fbposts_to_bPop_api(posts, fb_token, bpopToken, owner)
    #create likes / likes_data variables
    posts.each do |post|
      if post['likes']
        likes = post['likes']['data'].length
        likes_data = post['likes']['data'].to_json
      else
        likes = 0
        likes_data = "0"
      end

      if post['comments']
        comments = post['comments']['data'].length
        comments_data = post['comments']['data'].to_json
      else
        comments = 0
        comments_data = "0"
      end

      if post == posts.last
        is_last = 'true'
      else
        is_last = 'false'
      end
      #define params post request
      params = {
        fbpost: {
          owner: owner,
          story: post['story'],
          message: post['message'],
          picture: post['picture'],
          likes: likes,
          comments: comments,
          likes_data: likes_data,
          comments_data: comments_data,
          url: post['link'],
          date: post['created_time'][0..9],
          bpopToken: bpopToken,
          fb_user_token: fb_token,
          fb_post_id: post['id'],
          is_last: is_last
        }
      }
      #check if the user already connected facebook account
      if session[:facebook]
        #send put request to bPop_api to update posts
        response = Typhoeus::Request.new(
          "http://localhost:4000/fbposts/" + post['id'],
          method: :put,
          params: params
        ).run
      else
        #send post request to bPop_api to create posts (occurs first time only)
        response = Typhoeus::Request.new(
          "http://localhost:4000/fbposts",
          method: :post,
          params: params
        ).run
      end
    end
    session[:facebook] = 'loggedin'
  end
end
