class HomeController < ApplicationController

	before_action :current_user, :authenticate_user!, :user_signed_in?
	helper_method :search_byfan

  def index

		# posts_response = Typhoeus::Request.new(
		#   "http://localhost:4000/fbposts/" + current_user.bpopToken
		# ).run
		#
		#
		# likes_response = Typhoeus::Request.new(
		#   "http://localhost:4000/fblikes/" + current_user.bpopToken
		# ).run
		#
		# comments_response = Typhoeus::Request.new(
		# 	"http://localhost:4000/fbcomments/" + current_user.bpopToken
		# ).run
		#
		# @posts_stats = JSON.parse(posts_response.options[:response_body]).length
		# @likes_stats = JSON.parse(likes_response.options[:response_body])['count']
		# @comments_stats = JSON.parse(comments_response.options[:response_body])['count']
		#
		# gender_response = Typhoeus::Request.new(
		# 	"http://localhost:4000/get-gender-percentage/" + current_user.bpopToken
		# ).run
		#
		# @gender_stats = JSON.parse(gender_response.options[:response_body])
		#
		#
		# 	fans_response = Typhoeus::Request.new(
		# 	"http://localhost:4000/stats/topfan/" + current_user.bpopToken
		# ).run
		#
		# @active_fans = JSON.parse(fans_response.options[:response_body])[0]['activeUsers']
		# @fans = JSON.parse(fans_response.options[:response_body])[1]
		#
		# fan_response = Typhoeus::Request.new(
		# 	URI.encode("http://localhost:4000/stats/searchfan/" + current_user.bpopToken + "?userfan=Lisa+Di+Federico")
		# ).run
		#
		# @things_fan_likes = JSON.parse(fan_response.options[:response_body])
		#
		#
		# fanGroup_response = Typhoeus::Request.new(
		#   "http://localhost:4000/stats/searchgroup/" + current_user.bpopToken,
		#   method: :get,
		#   params: {"users_fans"=>["Lisa Di Federico", "Daniela Luna"]}
		# ).run
		#
		# @common_likes = JSON.parse(fanGroup_response.response_body)

  end



end
