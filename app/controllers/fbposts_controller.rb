class FbpostsController < ApplicationController
	def new
		for_user = identity.fb_authorize
		six_months_ago=Chronic.parse('six months ago').to_s[0..9]
		posts = for_user.get_object('me/posts?limit=5000&since=' + six_months_ago)
		binding.pry
		identity.fbposts.create(fbpost_params(for_user))
		
	end

	private

	def fbpost_params(for_user)

		
	end
end

