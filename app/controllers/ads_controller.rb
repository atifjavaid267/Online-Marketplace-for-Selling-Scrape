class AdsController < ApplicationController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @ads = @ads.published.paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def new
    @ad.user_id = current_user.id
    @ad.product_id = params[:product_id]

    @addresses = current_user.addresses
  end

  def create
    @ad = Ad.new(ad_params)
    @ad.user_id = current_user.id
    @addresses = current_user.addresses

    if @ad.save
      redirect_to @ad, notice: 'Ad was created successfully.'
    else
      render :new, notice: 'Ad was not created'
    end
  end

  def view_bids
    # Retrieve the ad and its bids
    @ad = Ad.find(params[:id])
    @bids = @ad.bids.where(status: 'pending').order(price: :desc).paginate(page: params[:page], per_page: 10)

    # Render the view
    render 'view_bids'
  end

  def edit
    @addresses = current_user.addresses
  end

  def update
    if @ad.update(ad_params)
      redirect_to @ad
    else
      render :edit
    end
  end

  def destroy
    # @ad = Ad.find(params[:id])
    flag = @ad.status

    if Bid.find_by(ad_id: @ad.id)
      if flag
        redirect_to ads_path, alert: 'Ad cannot be deleted!'
      else
        redirect_to archives_ads_path, alert: 'Ad cannot be deleted!'
      end
    else
      @ad.destroy
      if flag
        redirect_to ads_path, notice: 'Ad deleted successfully.'
      else
        redirect_to archives_ads_path, notice: 'Ad deleted successfully.'
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
    redirect_to ads_path
  end

  def archives
    @archive_ads = @ads.unpublished.paginate(page: params[:page], per_page: 10)
  end

  private

  def ad_params
    params.require(:ad).permit(:product_id, :price, :description, :address_id, ad_images: [])
  end
end
