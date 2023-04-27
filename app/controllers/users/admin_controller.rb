class Users::AdminController < ApplicationController

  def dashboard
    if current_user.seller?
      redirect_to seller_home_path
    elsif current_user.buyer?
      redirect_to buyer_home_path
    end
  end
end
