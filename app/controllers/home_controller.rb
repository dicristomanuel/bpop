require 'sse.rb'

class HomeController < ApplicationController

	before_action :user_signed_in?


	def check
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'

    sse = BpopApp1::SSE.new(response.stream)
    begin
      1.times do
        fans_data = current_user.fans_data

				completed = Typhoeus.get(
		      "https://bpop-api.herokuapp.com/is-complete/" + current_user.bpoptoken
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

	def get_carousel_numbers
		since = URI.escape(params[:since])
		subject = params[:subject]

		count_data =	Typhoeus.get(
			'https://bpop-api.herokuapp.com/fb' + subject + '/' + current_user.bpoptoken + '?since=' + since
		)
		if subject == 'likes'
			@number = JSON.parse(count_data.response_body)['likes'].length
		else
			@number = JSON.parse(count_data.response_body).length
		end
		render json: @number
	end

	def get_6_month_data
		@data = []

		posts =	Typhoeus.get(
			'https://bpop-api.herokuapp.com/fbposts/' + current_user.bpoptoken
		)

		likes =	Typhoeus.get(
			'https://bpop-api.herokuapp.com/fblikes/' + current_user.bpoptoken
		)

		comments =	Typhoeus.get(
			'https://bpop-api.herokuapp.com/fbcomments/' + current_user.bpoptoken
		)


		@data << { posts: 		JSON.parse(posts.response_body).length }
		@data << { likes: 		JSON.parse(likes.response_body)['count'] }
		@data << { comments: JSON.parse(comments.response_body).length }

		render json: @data
	end


	def get_gender_percentage
		gender_percentage =	Typhoeus.get(
			'https://bpop-api.herokuapp.com/get-gender-percentage/' + current_user.bpoptoken
		)

		@total_percentages = {
			male:   JSON.parse(gender_percentage.response_body)['total']['male'].round(),
		  female: JSON.parse(gender_percentage.response_body)['total']['female'].round()
		}

		render json: @total_percentages
	end


	def group_posts
		names = ''
		params[:names].each {|name| names += (URI.escape(name) + ',')}

		request_posts_for_group =	Typhoeus.get(
			'https://bpop-api.herokuapp.com/stats/searchgroup/' + current_user.bpoptoken + '?users_fans=' + names
		)

		@posts = request_posts_for_group.response_body

		render json: @posts
	end

	def single_fan
		name = URI.escape(params[:names])

		request_posts_for_group =	Typhoeus.get(
			'https://bpop-api.herokuapp.com/stats/searchfan/' + current_user.bpoptoken + '?userfan=' + name
		)

		@posts = request_posts_for_group.response_body

		render json: @posts
	end

	private

	def get_posts_1M(limit=nil)
		if limit
			request_monthly_posts =	Typhoeus.get(
				"https://bpop-api.herokuapp.com/fbposts/" + current_user.bpoptoken + "?since=one+month+ago&limit=" + limit.to_s
			).response_body
			JSON.parse(request_monthly_posts)
		else
		request_monthly_posts =	Typhoeus.get(
			"https://bpop-api.herokuapp.com/fbposts/" + current_user.bpoptoken + "?since=one+month+ago"
		)
		JSON.parse(request_monthly_posts.response_body)['count']
		end
	end


	def get_comments_1M(limit=nil)
		if limit
			request_monthly_comments =	Typhoeus.get(
				"https://bpop-api.herokuapp.com/fbcomments/" + current_user.bpoptoken + "?since=one+month+ago&limit=" + limit.to_s
			).response_body
			JSON.parse(request_monthly_comments)
		else
		request_monthly_comments =	Typhoeus.get(
			"https://bpop-api.herokuapp.com/fbcomments/" + current_user.bpoptoken + "?since=one+month+ago"
		)
		JSON.parse(request_monthly_comments.response_body)['count']
		end
	end


end
