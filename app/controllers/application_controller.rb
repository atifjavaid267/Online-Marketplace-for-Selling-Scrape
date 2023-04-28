class ApplicationController < ActionController::Base
  # for flash messages
  add_flash_types :info, :error, :warning

  before_action :authenticate_user!, except: %i[show_root]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  # for gem 'active_model_otp'
  # def authenticate_current_user_with_otp!
  #   return if devise_controller? || current_user.otp_authenticated?

  #   redirect_to(admin_otp_page_path)
  # end

  private

  def load_and_authorize_resource
    authorize! params[:action].to_sym, current_user
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:email, :password)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:first_name, :last_name, :email, :phone_no, :role, :password,
                         :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:edit) do |user_params|
      user_params.permit(:first_name, :last_name, :email, :phone_no, :password,
                         :password_confirmation, :current_password)
    end
  end
end
