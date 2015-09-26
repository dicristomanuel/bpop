require 'sse.rb'

class HomeController < ApplicationController

	before_action :user_signed_in?
	helper_method :get_posts_1W, :get_posts_1M, :get_posts_2M, :get_posts_3M, :get_posts_6M,
								:get_likes_1W, :get_likes_1M, :get_likes_2M, :get_likes_3M, :get_likes_6M,
								:get_comments_1W, :get_comments_1M, :get_comments_2M, :get_comments_3M, :get_comments_6M,
								:get_stats_for_carousel, :get_gender_percentage, :get_posts_for_group


	def check
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'

    sse = BpopApp1::SSE.new(response.stream)
    begin
      1.times do
        fans_data = current_user.fans_data

				completed = Typhoeus.get(
		      "http://localhost:4000/is-complete/" + current_user.bpopToken
		    ).response_body

 				carousel_comments = get_comments_1M(10)
				carousel_posts = get_posts_1M(10)

				if completed == 'true' && current_user.is_parsed == false
					ParseFacebook.perform_async(current_user.id)
				elsif completed == 'true' && current_user.is_parsed == true
          sse.write({fans_data: fans_data.as_json, posts: carousel_posts, comments: carousel_comments}, {event: 'refresh'})
        end
        sleep 1
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end

	def index
		@counter = 0
		current_user.update_attribute(:fans_data, '')
		current_user.update_attribute(:is_parsed, false)
  end

	def group_posts
		names = ''
		params[:names].each {|name| names += (URI.escape(name) + ',')}

		request_posts_for_group =	Typhoeus.get(
			'http://localhost:4000/stats/searchgroup/' + current_user.bpopToken + '?users_fans=' + names
		)

		@posts = request_posts_for_group.response_body

		render json: @posts
	end

	def single_fan
		name = URI.escape(params[:names])

		request_posts_for_group =	Typhoeus.get(
			'http://localhost:4000/stats/searchfan/' + current_user.bpopToken + '?userfan=' + name
		)

		@posts = request_posts_for_group.response_body

		render json: @posts
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

	# def get_comments_1W(limit=nil)
	# 	if limit
	# 		request_monthly_comments =	Typhoeus.get(
	# 			"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=one+week+ago&limit=" + limit.to_s
	# 		)
	# 	else
	# 	request_monthly_comments =	Typhoeus.get(
	# 		"http://localhost:4000/fbcomments/" + current_user.bpopToken + "?since=one+week+ago"
	# 	)
	# 	JSON.parse(request_monthly_comments.response_body)['count']
	# 	end
	# end

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
		{"comments" => get_comments_1M(10), "posts" => get_posts_1M(10)}
	end

	# def get_gender_percentage
	# 	gender_percentage =	Typhoeus.get(
	# 		"http://localhost:4000/get-gender-percentage/" + current_user.bpopToken
	# 	)
	# 	[JSON.parse(gender_percentage.response_body)['total']['male'].round, JSON.parse(gender_percentage.response_body)['total']['female'].round]
 # 	end


end
