# frozen_string_literal: true

# Ads Controller
class AdsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
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
    @ad.product_id = params[:product_id].to_i
    @addresses = {}
    current_user.addresses.each do |a|
      @addresses["#{a.street1} #{a.street2}, #{a.city},#{a.zip_code}, #{a.state}"] = a.id
    end
  end

  def create
    @ad.user_id = current_user.id
    if @ad.save
      flash[:notice] = 'Ad was successfully created'
      redirect_to @ad
    else
      flash[:alert] = @ad.errors.full_messages.join(', ')
      render :new
    end
  end

  def view_bids
    @bids = @ad.bids.pending.order(price: :desc).paginate(page: params[:page], per_page: 10)
  end

  def edit
    @addresses = {}
    current_user.addresses.each do |a|
      @addresses["#{a.street1} #{a.street2}, #{a.city},#{a.zip_code}, #{a.state}"] = a.id
    end
  end

  def update
    if @ad.update(ad_params)
      flash[:notice] = 'Ad was updated successfully'
      redirect_to @ad
    else
      flash[:alert] = @ad.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    if @ad.destroy
      flash[:notice] = 'Ad deleted successfully.'
    else
      flash[:alert] = @ad.errors.full_messages.join(', ')
    end
    redirect_to stored_location
  end

  def toggle_status
    if @ad.update_attribute(:status, !@ad.status)
      flash[:notice] = @ad.status == true ? 'Ad Published' : 'Ad Unpublished'
    else
      flash[:alert] = @ad.errors.full_messages.join(', ')
    end
    redirect_to stored_location
  end

  private

  def ad_params
    params.require(:ad).permit(:product_id, :price, :description, :address_id, ad_images: [])
  end
end
