# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:root]
  before_action :store_location, only: %i[home]

  def home; end

  def root; end

  def otp_setting; end

  def toggle_otp_status
    begin
      current_user.otp_secret = User.generate_otp_secret
      current_user.toggle_otp_required_for_login!
      current_user.save!
      flash[:notice] = "OTP #{current_user.otp_required_for_login ? 'enabled' : 'disabled'} successfully."
    rescue StandardError => e
      flash[:alert] = "Error: #{e.message}"
    end
    redirect_to users_otp_setting_path
  end
end
