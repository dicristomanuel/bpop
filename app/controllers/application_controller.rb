class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :current_user


  def user_signed_in?
    unless session[:user_id]
      flash[:alert] = "please signin"
      redirect_to new_user_session_path
    end
  end

  def current_user
    if session[:user_id]
      current_user = User.where(bpoptoken: session[:user_id]).first
    end
  end

end
