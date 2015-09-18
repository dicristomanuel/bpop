class HomeController < ApplicationController

	before_action :user_signed_in?
	helper_method :get_posts_1W, :get_posts_1M, :get_posts_2M, :get_posts_3M, :get_posts_6M,
								:get_likes_1W, :get_likes_1M, :get_likes_2M, :get_likes_3M, :get_likes_6M,
								:get_comments_1W, :get_comments_1M, :get_comments_2M, :get_comments_3M, :get_comments_6M,
								:get_stats_for_carousel, :get_gender_percentage

  def index
		@fans_data = []

		fans = Typhoeus.get(
			"http://localhost:4000/stats/topfan/" + current_user.bpopToken
		).response_body

		@top_fan = JSON.parse(fans)[1].first

		fan = Typhoeus.get(
			"http://localhost:4000/stats/get-fan-id/" + current_user.bpopToken + "?userFanName=" + URI.escape(@top_fan[0])
		).response_body

		fan_id = JSON.parse(fan)[0]

		@top_fan_pic = 'http://graph.facebook.com/' + fan_id + '/picture?width=300'
		@top_fan_link = 'http://www.facebook.com/' + fan_id

		JSON.parse(fans)[1].each_key do |key|
			this_fan_id = Typhoeus.get(
				"http://localhost:4000/stats/get-fan-id/" + current_user.bpopToken + "?userFanName=" + URI.escape(key)
			).response_body

			@fans_data << { fan_id: JSON.parse(this_fan_id)[0],
				fan_name: JSON.parse(this_fan_id)[1],
				fan_pic: 'http://graph.facebook.com/' + JSON.parse(this_fan_id)[0] + '/picture?width=300',
				fan_link: 'http://www.facebook.com/' + JSON.parse(this_fan_id)[0]
			} << '*******************************************************************'
		end


  end


	private

	# === GET POSTS ===

	def get_posts_1W(limit=nil)
		if limit
			request_monthly_posts =	Typhoeus.get(
				"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=one+week+ago&limit=" + limit.to_s
			)
		else
		request_monthly_posts =	Typhoeus.get(
			"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=one+week+ago"
		)
		end
		JSON.parse(request_monthly_posts.response_body)['count']
	end

	def get_posts_1M(limit=nil)
		if limit
			request_monthly_posts =	Typhoeus.get(
				"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=one+month+ago&limit=" + limit.to_s
			).response_body
			JSON.parse(request_monthly_posts)
		else
		request_monthly_posts =	Typhoeus.get(
			"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=one+month+ago"
		)
		JSON.parse(request_monthly_posts.response_body)['count']
		end
	end

	def get_posts_2M(limit=nil)
		if limit
			request_monthly_posts =	Typhoeus.get(
				"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=two+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_posts =	Typhoeus.get(
			"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=two+month+ago"
		)
		end
		JSON.parse(request_monthly_posts.response_body)['count']
	end

	def get_posts_3M(limit=nil)
		if limit
			request_monthly_posts =	Typhoeus.get(
				"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=three+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_posts =	Typhoeus.get(
			"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=three+month+ago"
		)
		end
		JSON.parse(request_monthly_posts.response_body)['count']
	end

	def get_posts_6M(limit=nil)
		if limit
			request_monthly_posts =	Typhoeus.get(
				"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=six+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_posts =	Typhoeus.get(
			"http://localhost:4000/fbposts/" + current_user.bpopToken + "?since=six+month+ago"
		)
		end
		JSON.parse(request_monthly_posts.response_body)['count']
	end


	# === GET LIKES ===

	def get_likes_1W(limit=nil)
		if limit
			request_monthly_likes =	Typhoeus.get(
				"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=one+week+ago&limit=" + limit.to_s
			)
		else
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=one+week+ago"
		)
		end
		JSON.parse(request_monthly_likes.response_body)['count']
	end

	def get_likes_1M(limit=nil)
		if limit
			request_monthly_likes =	Typhoeus.get(
				"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=one+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=one+month+ago"
		)
		end
		JSON.parse(request_monthly_likes.response_body)['count']
	end

	def get_likes_2M(limit=nil)
		if limit
			request_monthly_likes =	Typhoeus.get(
				"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=two+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=two+month+ago"
		)
		end
		JSON.parse(request_monthly_likes.response_body)['count']
	end

	def get_likes_3M(limit=nil)
		if limit
			request_monthly_likes =	Typhoeus.get(
				"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=three+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=three+month+ago"
		)
		end
		JSON.parse(request_monthly_likes.response_body)['count']
	end

	def get_likes_6M(limit=nil)
		if limit
			request_monthly_likes =	Typhoeus.get(
				"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=six+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_likes =	Typhoeus.get(
			"http://localhost:4000/fblikes/" + current_user.bpopToken + "?since=six+month+ago"
		)
		end
		JSON.parse(request_monthly_likes.response_body)['count']
	end


	# === GET COMMENTS ===

	def get_comments_1W(limit=nil)
		if limit
			request_monthly_comments =	Typhoeus.get(
				"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=one+week+ago&limit=" + limit.to_s
			)
		else
		request_monthly_comments =	Typhoeus.get(
			"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=one+week+ago"
		)
		JSON.parse(request_monthly_comments.response_body)['count']
		end
	end

	def get_comments_1M(limit=nil)
		if limit
			request_monthly_comments =	Typhoeus.get(
				"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=one+month+ago&limit=" + limit.to_s
			).response_body
			JSON.parse(request_monthly_comments)
		else
		request_monthly_comments =	Typhoeus.get(
			"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=one+month+ago"
		)
		JSON.parse(request_monthly_comments.response_body)['count']
		end
	end

	def get_comments_2M(limit=nil)
		if limit
			request_monthly_comments =	Typhoeus.get(
				"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=two+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_comments =	Typhoeus.get(
			"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=two+month+ago"
		)
		JSON.parse(request_monthly_comments.response_body)['count']
		end
	end

	def get_comments_3M(limit=nil)
		if limit
			request_monthly_comments =	Typhoeus.get(
				"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=three+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_comments =	Typhoeus.get(
			"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=three+month+ago"
		)
		JSON.parse(request_monthly_comments.response_body)['count']
		end
	end

	def get_comments_6M(limit=nil)
		if limit
			request_monthly_comments =	Typhoeus.get(
				"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=six+month+ago&limit=" + limit.to_s
			)
		else
		request_monthly_comments =	Typhoeus.get(
			"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=six+month+ago"
		)
		JSON.parse(request_monthly_comments.response_body)['count']
		end
	end

	# ======================

	def get_stats_for_carousel
		{'comments' => get_comments_1M(10), 'posts' => get_posts_1M(10)}
	end

	def get_gender_percentage
		gender_percentage =	Typhoeus.get(
			"http://localhost:4000/get-gender-percentage/" + current_user.bpopToken
		)
		[JSON.parse(gender_percentage.response_body)['total']['male'].round, JSON.parse(gender_percentage.response_body)['total']['female'].round]
 	end


end
