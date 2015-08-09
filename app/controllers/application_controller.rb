class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :get_posts


  # facebook scraping Chronic.parse('last week')

  def get_posts(for_user, since_this_date=Chronic.parse('last week').to_s[0..9])
  	posts = for_user.get_object('me/posts?since=' + since_this_date)
  end

end
