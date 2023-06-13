# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  add_flash_types :notice, :alert
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_notifications,  if: :user_signed_in?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  private

  def load_notifications
    @notifications = current_user.received_notifications.unread
  end

  def store_location
    session[:stored_location] = request.path
  end

  def stored_location
    session[:stored_location] || root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])

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
