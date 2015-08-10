class FblikesController < ApplicationController
	def new
		post.fblikes.create(fblikes_params(post, like))
		redirect_to :back
	end

	private
		def fblikes_params(post, like)
			binding.pry
		end
end
