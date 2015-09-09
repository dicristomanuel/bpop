class Users::SessionsController < Devise::SessionsController

  # GET /resource/sign_in
  def new
    if current_user
      @fb_connected = current_user.identities.any? {|social| social.provider.include?('facebook')}
      @tw_connected = current_user.identities.any? {|social| social.provider.include?('twitter')}
    end

      if @fb_connected
        find_provider_fb = current_user.identities.select {|social| social.provider = 'facebook'}
        @fb_profile_pic = find_provider_fb.first.image_url
        @fb_name = find_provider_fb.first.name.upcase
      end

      if @tw_connected
        find_provider_tw = current_user.identities.select {|social| social.provider = 'twitter'}
        @tw_profile_pic = find_provider_tw.first.image_url
        @tw_name = find_provider_tw.first.name.upcase
      end
  end

  # POST /resource/sign_in
  def create
    @user = User.where(email: params[:user][:email])
      if @user.empty?
        flash[:alert] = "invalid credentials"
        redirect_to :back
      else
        flash[:notice] = "user loggedin!"
        session[:user_id] = @user.first.bpopToken
        redirect_to 'http://localhost:3000/users/sign_in#/success'
      end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  private

  # If you have extra params to permit, append them to the sanitizer.
  def user_params
    params.require(:user).permit(:email, :password)
  end

  def after_sign_in_path_for
    redirect_to user_session_path
  end
end
