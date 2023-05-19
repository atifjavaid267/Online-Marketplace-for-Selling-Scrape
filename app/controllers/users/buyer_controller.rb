class Users::BuyerController < ApplicationController
  def home
    @ads = Ad.published.paginate(page: params[:page], per_page: 10)
    if current_user.seller?
      redirect_to seller_home_path
    elsif current_user.admin?
      redirect_to admin_dashboard_path
    end
  end
end
