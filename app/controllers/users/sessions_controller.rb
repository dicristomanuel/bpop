# class Users::SessionsController < Devise::SessionsController
class Users::SessionsController < ApplicationController


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
  end


  def create
    are_valid_credentials = User.find_by_email(params[:user][:email]).try(:valid_password?, params[:user][:password])
      if !are_valid_credentials
        flash[:alert] = "invalid credentials"
        redirect_to :back
      else
        @user = User.find_by_email(params[:user][:email])
        session[:user_id] = @user.bpopToken
          if current_user.identities.select {|social| social.provider == 'facebook'}
            session[:facebook] = 'loggedin'
          end
          if current_user.identities.select {|social| social.provider == 'twitter'}
            session[:twitter] = 'loggedin'
          end
        # redirect_to 'http://localhost:3000/users/sign_in#/success'
        redirect_to 'http://localhost:3000/users/auth/facebook'
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
