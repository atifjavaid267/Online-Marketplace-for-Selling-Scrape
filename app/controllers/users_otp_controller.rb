class UsersOtpController < ApplicationController
  before_action :authenticate_user!
  before_action :store_location, only: %i[settings]

  def settings; end

  def toggle
    current_user.otp_secret = User.generate_otp_secret
    current_user.otp_required_for_login = !current_user.otp_required_for_login
    current_user.save!
    redirect_to stored_location
  end
end
