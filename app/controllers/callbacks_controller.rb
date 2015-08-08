class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
  		user = current_user
      user.identities.create(provider: request.env["omniauth.auth"].provider)
      redirect_to root_path
  end
end
