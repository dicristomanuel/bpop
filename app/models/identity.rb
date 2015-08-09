class Identity < ActiveRecord::Base
	belongs_to :User

	# scraping information
  def fb_authorize
	 Koala::Facebook::API.new(access_token)
  end
end
