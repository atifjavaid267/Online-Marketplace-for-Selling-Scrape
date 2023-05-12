class AdsController < ApplicationController
  load_and_authorize_resource

  before_action :store_location, only: %i[new index archives]

  def index
    @ads = @ads.published.paginate(page: params[:page], per_page: 10)
  end

  def archives
    @archive_ads = @ads.unpublished.paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def new
    @ad.user_id = current_user.id
    @ad.product_id = params[:product_id]

    @addresses = current_user.addresses
  end

  def create
    @ad.user_id = current_user.id
    @addresses = current_user.addresses

    if @ad.save
      redirect_to @ad, notice: 'Ad was created successfully.'
    else
      redirect stored_location, notice: 'Ad was not created.'
    end
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
    @ad.destroy
    redirect_to stored_location, notice: 'Ad deleted successfully.'
  end

  def view_bids
    @bids = @ad.bids.pending.order(price: :desc).paginate(page: params[:page], per_page: 10)
  end

  def toggle_published
    @ad.update_attribute(:status, !@ad.status)
    redirect_to stored_location
  end

  private

  def ad_params
    params.require(:ad).permit(:product_id, :price, :description, :address_id, ad_images: [])
  end
end
