class UsersOtpController < ApplicationController
  before_action :authenticate_user!

  def toggle_otp_enable
    current_user.otp_secret = User.generate_otp_secret
    current_user.otp_required_for_login = !current_user.otp_required_for_login
    current_user.save!
    redirect_back(fallback_location: root_path)
  end
end
