class Users::HomeController < ApplicationController
  def dashboard
    @ads = Ad.published.paginate(page: params[:page], per_page: 10)
  end
end
