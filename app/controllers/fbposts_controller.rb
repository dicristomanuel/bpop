class FbpostsController < ApplicationController
	def create
		identity = Identity.find_by_id(params[:identity_id])
		for_user = identity.fb_authorize
		six_months_ago=Chronic.parse('six months ago').to_s[0..9]
		posts = for_user.get_object('me/posts?limit=5000&since=' + six_months_ago)
		posts.each do |post|
		identity.fbposts.create(fbpost_params(post, identity))
		end
		render :back
	end

	private

	def fbpost_params(post, identity)
		if post['likes']
			likes = post['likes']['data'].length

				# post['likes']['data'].each do |like| 
				# 	redirect_to new_user_identity_fbpost_fblike_path(current_user, identity, post, like)
				# end
		else 
			likes = 0
		end
		
		params = {
			story: post["story"],
			message: post["message"],
			url: post["link"],
			date: post["created_time"],
			likes: likes
		}
			#CREATE LIKES WITH ALL THE FIELDS
			#NEXT COMMENTS
			#NEXT TWITTER
	end
end

