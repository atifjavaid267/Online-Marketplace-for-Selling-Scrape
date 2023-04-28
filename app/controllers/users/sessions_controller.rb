# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # before_action :configure_sign_in_params, only: [:create]

  before_action :authenticate_user!, except: %i[new create destroy]
  before_action :load_and_authorize_resource, except: %i[new create destroy]

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
