########OVERRIDING DEVISE CONTROLLER

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    @user = User.where(email: params[:user][:email])
    if @user.first
      flash[:notice] = "email sent!"
      redirect_to :back
    else
      flash[:alert] = "email not found"
      redirect_to :back
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    super
  end

  protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    super(resource_name)
  end
end
