class Users::SellerController < ApplicationController


  def home
    if current_user.buyer?
      redirect_to buyer_home_path
    elsif current_user.admin?
      redirect_to admin_dashboard_path
    end
  end

end
