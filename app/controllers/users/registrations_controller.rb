
require 'securerandom'
require 'rotp/base32'
require 'openssl'

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    existing_user = User.find_by_email(sign_up_params[:email])
    if existing_user
      flash[:alert] = "This email is already registered as #{existing_user.role}"
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
  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name phone_no role])
  end

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
end
