class AdsController < ApplicationController
  def index
    @ads = Ad.all
  end

  def new
    if current_user.seller?
      @ad = Ad.new
      @user_addresses = current_user.addresses
    end
  end

  def create
    if current_user.seller?
      @ad = Ad.new(ad_params)
      @ad.user_id = current_user.id
    end
  end

  def destroy
    @ad = Ad.find(params[:id])
    @product.destroy
    redirect_to ads_path, notice: 'Product deleted successfully.'
  end

  private

  def ad_params
    params.require(:ad).permit(:name, :description, :product_image)
  end

end
