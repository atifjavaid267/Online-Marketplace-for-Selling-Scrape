# frozen_string_literal: true

# Ads Controller
class AdsController < ApplicationController
  include Pagination
  load_and_authorize_resource :product, only: %i[new create]
  load_and_authorize_resource through: :product, only: %i[new create]
  load_and_authorize_resource except: %i[new create]

  before_action :authenticate_user!
  before_action :store_location, only: %i[new edit index]

  def index
    @ads = paginate_records(@ads.includes([:product], [:ad_images_attachments]).by_archived(params[:archived] || false))
  end

  def show; end

  def new
      @addresses = current_user.addresses.pluck(:full_address, :id)
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
    @bids = paginate_records(@ad.bids.includes([:user]).pending.order(price: :desc))
  end

  def edit
    @addresses = current_user.addresses.pluck(:full_address, :id)
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

  def toggle_archived
    if @ad.update_attribute(:archived, !@ad.archived)
      flash[:notice] = @ad.archived ? 'Ad Unpublished' : 'Ad Published'
    else
      flash[:alert] = @ad.errors.full_messages.join(', ')
    end
    redirect_to ads_path
  end

  private

  def ad_params
    params.require(:ad).permit(:product_id, :price, :description, :address_id, ad_images: [])
  end
end
