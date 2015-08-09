class Identity < ActiveRecord::Base
	belongs_to :User
	has_many :fbposts, dependent: :destroy

	# scraping information
  def fb_authorize
	 Koala::Facebook::API.new(access_token)
  end
end
