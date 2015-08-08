class HomeController < ApplicationController

	before_action :current_user, :authenticate_user!, :user_signed_in?

  def index
  end
end
