class PostsFacebook
  include Sidekiq::Worker

  def perform(posts, fb_token, bpoptoken, owner, session)
    #API call post request to bPop_api for fbposts / passing posts, tokens and owner's name
    fbposts_to_bPop_api(posts, fb_token, bpoptoken, owner, session)
  end

  def fbposts_to_bPop_api(posts, fb_token, bpoptoken, owner, session)
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
          bpoptoken: bpoptoken,
          fb_user_token: fb_token,
          fb_post_id: post['id'],
          is_last: is_last
        }
      }

        #send post request to bPop_api to create or update posts
        response = Typhoeus::Request.new(
          "https://bpop-api.herokuapp.com/fbposts",
          method: :post,
          params: params
        ).run
    end
  end

end
