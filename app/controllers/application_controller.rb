class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :get_posts, :get_friends, :get_gender, :get_percentage_of_genders, :display_posts


  # facebook scraping Chronic.parse('last week')

  def all_posts(identity)
  	@all_posts = get_posts(identity, Chronic.parse('ten years ago').to_s[0..9]).length
  end

  def get_posts(for_user, since="a week ago")
  	since_this_date=Chronic.parse(since).to_s[0..9]
  	for_user.get_object('me/posts?limit=5000&since=' + since_this_date)
  end

  def display_posts(posts_to_display, field_to_display)
  	posts_requested = []
		  posts_to_display.each do |post|
				posts_requested << [post[field_to_display], post["link"]]
			end
		posts_requested
  end

  def get_friends(for_user)
		friends = for_user.get_object('10206075804227611?fields=first_name')
  end

  def get_gender(for_user, for_friend)
  	@genders = []
  	friend = for_user.get_object(for_friend + '?fields=first_name')
  	gender = Guess.gender(friend["first_name"])[:gender]
  end

  def get_percentage_of_genders(counts)
  	total = counts.values.inject(:+)
  	female_percentage = (100).to_f / (total).to_f * counts["female"].to_f
  	male_percentage = 100 - female_percentage
  	"female #{female_percentage.to_i}%, male #{male_percentage.to_i}%"

  end

end
