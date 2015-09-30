class Identity < ActiveRecord::Base

	belongs_to :User
	validates :access_token, presence: true, uniqueness: true
	# exchanging token for auth
  def fb_authorize(access_token)
	 Koala::Facebook::API.new(access_token)
  end
end
