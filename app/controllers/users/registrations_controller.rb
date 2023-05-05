# frozen_string_literal: true

require 'securerandom'
require 'rotp/base32'
require 'openssl'

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_2fa!, only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # authenticate_2fa!
    existing_user = User.find_by_email(sign_up_params[:email])
    if existing_user
      flash[:notice] = "This email is already registered as #{existing_user.role}"
      redirect_to new_user_registration_path
    else
      super do |resource|
        if resource.valid? && resource.persisted?

          resource.update(
            otp_required_for_login: true,
            otp_secret: User.generate_otp_secret
          )
        end
      end
    end
  end

  # #### for gem 'devise-two-factor' #####
  # def authenticate_2fa!
  #   user = find_user
  #   self.resource = user

  #   return unless user

  #   if user_params[:otp_attempt].present?
  #     auth_with_2fa(user)
  #   elsif user.valid_password?(user_params[:password]) && user.otp_required_for_login
  #     session[:user_id] = user.id
  #     CodeMailer.send_code(user).deliver_now
  #     render 'users_otp/two_fa'
  #   end
  # end

  # def auth_with_2fa(user)
  #   return unless user.validate_and_consume_otp!(user_params[:otp_attempt])

  #   user.save!
  #   sign_in(user)
  # end

  # def find_user
  #   if session[:user_id]
  #     User.find(session[:user_id])
  #   elsif user_params[:email]
  #     User.find_by(email: user_params[:email])
  #   end
  # end

  # def user_params
  #   params.fetch(:user, {}).permit(:password, :otp_attempt, :email, :remember_me)
  # end

  # #####################

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end
  # protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_no, :role])
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_no])
  # end
  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name phone_no role])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name phone_no])
  end

  def after_sign_up_path_for(resource)
    if resource.seller?
      seller_home_path
    elsif resource.buyer?
      buyer_home_path
    else
      super(resource)
    end
  end

  def after_update_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    elsif resource.seller?
      seller_home_path
    elsif resource.buyer?
      buyer_home_path
    else
      super(resource)
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
