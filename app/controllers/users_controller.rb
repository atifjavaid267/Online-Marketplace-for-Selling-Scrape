# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  include Pagination
  before_action :authenticate_user!, except: [:root]
  before_action :store_location, only: %i[otp_setting home]

  def home; end

  def root
    @products = paginate_records(Product.includes([product_image_attachment: :blob]).by_archived(false))
  end

  def otp_setting; end

  def toggle_otp_status
    begin
      current_user.otp_secret = User.generate_otp_secret
      current_user.otp_required_for_login = !current_user.otp_required_for_login
      current_user.save!
    rescue StandardError => e
      flash[:alert] = "Error: #{e.message}"
    end
    redirect_to stored_location
  end
end
