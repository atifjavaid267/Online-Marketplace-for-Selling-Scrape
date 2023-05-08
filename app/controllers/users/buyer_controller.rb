class Users::BuyerController < ApplicationController
  def home
    if current_user.seller?
      redirect_to seller_home_path
    elsif current_user.admin?
      redirect_to admin_dashboard_path
    end
  end
end
