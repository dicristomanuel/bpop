class ParseFacebook
  include Sidekiq::Worker

  def perform(id)
    user = User.where(id: id)
    bpoptoken = user.first.bpoptoken
    fans_data = []

    fans = Typhoeus.get(
      "https://bpop-api.herokuapp.com/stats/topfan/" + bpoptoken
    ).response_body

    JSON.parse(fans)[1].each do |key, value|
      this_fan_id = Typhoeus.get(
        "https://bpop-api.herokuapp.com/stats/get-fan-id/" + bpoptoken + "?userFanName=" + URI.escape(key)
      ).response_body

      fans_data << { fan_id: JSON.parse(this_fan_id)[0],
        fan_name: JSON.parse(this_fan_id)[1],
        fan_pic: 'http://graph.facebook.com/' + JSON.parse(this_fan_id)[0] + '/picture?width=300&height=300',
        fan_link: 'http://www.facebook.com/' + JSON.parse(this_fan_id)[0],
        fan_interactions: value
      }

    end

    User.where(bpoptoken: bpoptoken).update_all({fans_data: fans_data, is_parsed: true})
  end
end
