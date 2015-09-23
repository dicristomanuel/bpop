class ParseFacebook
  include Sidekiq::Worker

  def perform(bpopToken)
    fans_data = []

    fans = Typhoeus.get(
      "http://localhost:4000/stats/topfan/" + current_user.bpopToken
    ).response_body



    top_fan = JSON.parse(fans)[1].first

    fan = Typhoeus.get(
      "http://localhost:4000/stats/get-fan-id/" + current_user.bpopToken + "?userFanName=" + URI.escape(@top_fan[0])
    ).response_body

    fan_id = JSON.parse(fan)[0]

    top_fan_pic = 'http://graph.facebook.com/' + fan_id + '/picture?width=300'
		top_fan_link = 'http://www.facebook.com/' + fan_id




  		JSON.parse(fans)[1].each do |key, value|
  			this_fan_id = Typhoeus.get(
  				"http://localhost:4000/stats/get-fan-id/" + bpopToken + "?userFanName=" + URI.escape(key)
  			).response_body

  			fans_data << { fan_id: JSON.parse(this_fan_id)[0],
  				fan_name: JSON.parse(this_fan_id)[1],
  				fan_pic: 'http://graph.facebook.com/' + JSON.parse(this_fan_id)[0] + '/picture?width=300&height=300',
  				fan_link: 'http://www.facebook.com/' + JSON.parse(this_fan_id)[0],
  				fan_interactions: value
  			}
  		end
      User.where(bpopToken: bpopToken).update_all(fans_data: fans_data)
  end
end
