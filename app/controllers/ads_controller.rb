class AdsController < ApplicationController
  def index
    @ads = Ad.all
  end

  def display_ads
    @ads = current_user.ads
  end

  def show
    @ad = Ad.find(params[:id])
  end

  def new
    if current_user.seller?
      @product = Product.find(params[:product_id])
      @ad = @product.ads.new

      @ad.user_id = current_user.id
      @addresses = current_user.addresses
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def create
    if current_user.seller?
      # @ad = Ad.new(ad_params)
      @product = Product.find(params[:product_id])
      @ad = @product.ads.build(ad_params)

      @ad.user_id = current_user.id

      # byebug

      if @ad.save!
        redirect_to @ad, notice: "Ad was successfully created."
      else
        # render :new
        redirect_to new_product_ad_path(@product)
      end
    end
  end

  def destroy
    @ad = Ad.find(params[:id])
    @product.destroy
    redirect_to ads_path, notice: 'Product deleted successfully.'
  end

  private

  def ad_params
    params.require(:ad).permit(:product_id, :price, :description, :address_id, :ad_images)
  end

end
