# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # before_action :configure_sign_in_params, only: [:create]

  # for gem 'devise-two-factor'
  before_action :authenticate_2fa!, only: [:create]

  before_action :authenticate_user!, except: %i[new create destroy]
  before_action :load_and_authorize_resource, except: %i[new create destroy]

  before_action :authenticate_2fa!, only: [:new, :create]

  #### for gem 'devise-two-factor' #####
  def authenticate_2fa!
    user = find_user
    self.resource = user

    return unless user

    if user_params[:otp_attempt].present?
      auth_with_2fa(user)
    elsif user.valid_password?(user_params[:password]) && user.otp_required_for_login
      session[:user_id] = user.id
      CodeMailer.send_code(user).deliver_now
      render 'users_otp/two_fa'
    end
  end

  def auth_with_2fa(user)
    return unless user.validate_and_consume_otp!(user_params[:otp_attempt])

    user.save!
    sign_in(user)
  end

  def find_user
    if session[:user_id]
      User.find(session[:user_id])
    elsif user_params[:email]
      User.find_by(email: user_params[:email])
    end
  end

  def user_params
    params.fetch(:user, {}).permit(:password, :otp_attempt, :email, :remember_me)
  end

  #####################

  def new
    return if user_signed_in?

    super
  end

  # POST /resource/sign_in
  def create
    if user_signed_in?
      if current_user.admin?
        redirect_to admin_dashboard_path
      elsif current_user.seller?
        redirect_to seller_home_path
      elsif current_user.buyer?
        redirect_to buyer_home_path
      end
    else
      super
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
