class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
      @user = User.create(user_params)

      new_user_on_api = Typhoeus::Request.new(
        "https://bpop-api.herokuapp.com/create-user/" + @user.bpoptoken
      ).run

      if @user.errors.messages[:password]
        flash[:alert] = @user.errors.messages[:password][0]
        redirect_to 'http://localhost:3000/users/sign_in#/signup'
      elsif @user.errors.messages[:email]
        flash[:alert] = @user.errors.messages[:email][0]
        redirect_to 'http://localhost:3000/users/sign_in#/signup'
      elsif @user.errors.messages[:password_confirmation]
        flash[:alert] = @user.errors.messages[:password_confirmation][0]
        redirect_to 'http://localhost:3000/users/sign_in#/signup'
      else
        session[:user_id] = @user.bpoptoken
        redirect_to 'http://localhost:3000/users/sign_in#/success'
      end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # TODO delete this?
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << :attribute
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end
end
