# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  add_flash_types :notice, :alert

  before_action :authenticate_user!, except: %i[root]
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  def find_user
    if session[:user_id]
      User.find(session[:user_id])
    elsif user_params[:email]
      User.find_by(email: user_params[:email])
    end
  end

  def auth_with_2fa(user)
    return unless user.validate_and_consume_otp!(user_params[:otp_attempt])

    user.save!
    sign_in(user)
  end

  def authenticate_2fa!
    user = find_user
    self.resource = user

    return unless user

    if user_params[:otp_attempt].present?
      auth_with_2fa(user)
    elsif user.valid_password?(user_params[:password]) && user.otp_required_for_login
      session[:user_id] = user.id
      CodeMailer.send_code(user).deliver_now
      @code = User.generate_otp(user.otp_secret)
      send_message(@code)
      render 'users/two_factor'
    end
  end

  def send_message(code)
    twilio_number = '+14345108668'
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    client.messages.create(
      from: twilio_number,
      to: '+923081186267',
      body: "Your OTP is #{code}"
    )
  end

  private

  def store_location
    session[:stored_location] = request.path
  end

  def stored_location
    session[:stored_location]
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
