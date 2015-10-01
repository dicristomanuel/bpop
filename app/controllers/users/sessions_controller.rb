# class Users::SessionsController < Devise::SessionsController
class Users::SessionsController < ApplicationController
require 'pry-rails'

  def new
    if current_user
      @fb_connected = current_user.identities.any? {|social| social.provider.include?('facebook')}
      @tw_connected = current_user.identities.any? {|social| social.provider.include?('twitter')}
    end

      if @fb_connected
        find_provider_fb = current_user.identities.select {|social| social.provider == 'facebook'}
        @fb_profile_pic = find_provider_fb.first.image_url
        @fb_name = find_provider_fb.first.name.upcase
      end

      if @tw_connected
        find_provider_tw = current_user.identities.select {|social| social.provider == 'twitter'}
        @tw_profile_pic = find_provider_tw.first.image_url
        @tw_name = find_provider_tw.first.name.upcase
      end

      if not flash[:alert].nil? and flash[:alert].include?('acebook')
        flash[:alert] = ""
        flash[:alert_social] = "please try again"
      end

      render "/users/sessions/new"

  end


  def create
    are_valid_credentials = User.find_by_email(params[:user][:email]).try(:valid_password?, params[:user][:password])
      if !are_valid_credentials
        flash[:alert] = "invalid credentials"
        redirect_to :back
      else
        @user = User.find_by_email(params[:user][:email])
        session[:user_id] = @user.bpoptoken
          if current_user.identities.select {|social| social.provider == 'facebook'}
            session[:facebook] = 'loggedin'
          end
          if current_user.identities.select {|social| social.provider == 'twitter'}
            session[:twitter] = 'loggedin'
          end

        flash[:alert] = ""

        if current_user.identities.any? {|identity| identity[:provider].include?('facebook')}
          redirect_to '/users/auth/facebook'
        else
          redirect_to '/users/sign_in#/success'
        end
      end
  end


  def destroy
    session[:user_id] = nil
    session[:facebook] = nil
    session[:twitter] = nil
    redirect_to root_path
  end

  private

  # If you have extra params to permit, append them to the sanitizer.
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
