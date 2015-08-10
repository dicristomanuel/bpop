class Identity < ActiveRecord::Base

	belongs_to :User
	has_many :fbposts, dependent: :destroy

	# exchanging token for auth
  def fb_authorize(access_token)
	 Koala::Facebook::API.new(access_token)
  end
end
