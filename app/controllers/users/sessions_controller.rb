# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_2fa!, only: %i[new create]
  before_action :authenticate_user!, except: %i[new create destroy]
  before_action :load_and_authorize_resource, except: %i[new create destroy]

  def new
    return if user_signed_in?

    super
  end

  def create
    if user_signed_in?
      redirect_to users_home_path
    else
      super
    end
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:password, :otp_attempt, :email, :remember_me)
  end

  def find_user
    if session[:user_id]
      User.find(session[:user_id])
    elsif user_params[:email]
      User.find_by(email: user_params[:email])
    end
  end

  def authenticate_2fa!
    user = find_user
    self.resource = user
    return unless user

    if user_params[:otp_attempt].present?
      auth_with_2fa(user)
    elsif user.valid_password?(user_params[:password]) && user.otp_required_for_login
      session[:user_id] = user.id
      DeviseTwoFactorAuth.new(user).send_message
      render 'users/two_factor'
    end
  end

  def auth_with_2fa(user)
    return unless user.validate_and_consume_otp!(user_params[:otp_attempt])

    user.save!
    sign_in(user)
  end
end
