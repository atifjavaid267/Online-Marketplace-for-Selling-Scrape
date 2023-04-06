class AdsController < ApplicationController
  def index
    @ads = Ad.all.where(status: true).paginate(page: params[:page], per_page: 10)
  end

  def display_ads
    @ads = current_user.ads.where(status: true).paginate(page: params[:page], per_page: 10)
  end

  def show
    @ad = Ad.find(params[:id])
  end

  def new
    @product = Product.find(params[:product_id])
    @ad = @product.ads.new

    @ad.user_id = current_user.id
    @addresses = current_user.addresses
  end

  def view_bids
    # Retrieve the ad and its bids
    @ad = Ad.find(params[:id])
    @bids = @ad.bids.paginate(page: params[:page], per_page: 10)

    # Render the view
    render 'view_bids'
  end

  def create
    return unless current_user.seller?

    # @ad = Ad.new(ad_params)
    @product = Product.find(params[:product_id])
    @ad = @product.ads.build(ad_params)

    @ad.user_id = current_user.id

    if @ad.save
      redirect_to @ad, notice: 'Ad was successfully created.'
    else
      redirect_to new_product_ad_path(@product)
    end
  end

  def edit
    @ad = Ad.find(params[:id])
    @addresses = current_user.addresses
  end

  def update
    @ad = Ad.find(params[:id])

    if @ad.update(ad_params)
      redirect_to @ad
    else
      render :edit
    end
  end

  def destroy
    @ad = Ad.find(params[:id])
    flag = @ad.status

    if Bid.find_by(ad_id: @ad.id)
      if current_user.admin?
        redirect_to ads_path, alert: 'Ad cannot be deleted!'
      else
        if flag
          redirect_to seller_ads_path, alert: 'Ad cannot be deleted!'
        else
          redirect_to archives_ads_path, alert: 'Ad cannot be deleted!'
        end
      end
    else
      @ad.destroy
      if current_user.admin?
        if flag
          redirect_to ads_path, notice: 'Ad deleted successfully.'
        else
          redirect_to archives_ads_path, notice: 'Ad deleted successfully.'
        end
      else
        if flag
          redirect_to seller_ads_path, notice: 'Ad deleted successfully.'
        else
          redirect_to archives_ads_path, notice: 'Ad deleted successfully.'
        end
      end
    end
  end

  def publish
    @ad = Ad.find(params[:id])
    @ad.update_attribute(:status, !@ad.status)
    redirect_to archives_ads_path
  end

  def unpublish
    @ad = Ad.find(params[:id])
    @ad.update_attribute(:status, !@ad.status)
    redirect_to seller_ads_path
  end

  def archives
    if current_user.admin?
      @archive_ads = Ad.where(status: false).paginate(page: params[:page], per_page: 10)
    elsif current_user.seller?
      @archive_ads = current_user.ads.where(status: false).paginate(page: params[:page], per_page: 10)
    end
  end

  private

  def ad_params
    params.require(:ad).permit(:product_id, :price, :description, :address_id, ad_images: [])
  end
end
