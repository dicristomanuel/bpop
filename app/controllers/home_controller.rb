class HomeController < ApplicationController

	before_action :user_signed_in?
	helper_method :get_likes_1W, :get_likes_1M, :get_likes_2M, :get_likes_3M, :get_likes_6M

  def index

  end


	private

	def get_likes_1W
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=one+week+ago"
		)
		JSON.parse(request_monthly_likes.response_body)['count']
	end

	def get_likes_1M
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=one+month+ago"
		)
		JSON.parse(request_monthly_likes.response_body)['count']
	end

	def get_likes_2M
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=two+month+ago"
		)
		JSON.parse(request_monthly_likes.response_body)['count']
	end

	def get_likes_3M
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=three+month+ago"
		)
		JSON.parse(request_monthly_likes.response_body)['count']
	end

	def get_likes_6M
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=six+month+ago"
		)
		JSON.parse(request_monthly_likes.response_body)['count']
	end


end
