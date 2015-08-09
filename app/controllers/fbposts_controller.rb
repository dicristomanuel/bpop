class FbpostsController < ApplicationController
	def new
		identity = Identity.find_by_id(params[:identity_id])
		for_user = identity.fb_authorize
		six_months_ago=Chronic.parse('six months ago').to_s[0..9]
		posts = for_user.get_object('me/posts?limit=5000&since=' + six_months_ago)
		posts.each do |post|
		identity.fbposts.create(fbpost_params(post, identity))
		end
		redirect_to root_path
	end

	private

	def fbpost_params(post, identity)
		binding.pry
		{
			story: post["story"],
			message: post["message"],
			url: post["link"],
			date: post["created_time"]
		}
		
		if post["likes"]
			new_user_identity_fbpost_fblike(current_user, identity, post)
			#CREATE LIKES WITH ALL THE FIELDS
			#NEXT COMMENTS
			#NEXT TWITTER
		end

	end
end

