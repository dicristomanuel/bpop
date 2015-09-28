class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
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
