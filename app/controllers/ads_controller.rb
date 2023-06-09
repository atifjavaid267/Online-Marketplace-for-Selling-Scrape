# frozen_string_literal: true

# Ads Controller
class AdsController < ApplicationController
  load_and_authorize_resource :product, only: %i[new create]
  load_and_authorize_resource through: :product, only: %i[new create]
  load_and_authorize_resource except: %i[new create]

  before_action :store_location, only: %i[new edit index show]

  def index
    @ads = params[:status] == 'archived' ? @ads.archived : @ads.unarchived
    @ads = @ads.includes([:product], [:ad_images_attachments]).page(params[:page])
  end

  def show; end

  def new; end

  def create
    @ad.user_id = current_user.id
    if @ad.save
      flash[:notice] = 'Ad created successfully.'
      redirect_to @ad
    else
      flash[:alert] = @ad.errors.full_messages.join(', ')
      render :new
    end
  end

  def view_bids
    @bids = @ad.bids.includes([:user]).pending.sort_by_price('desc').page(params[:page])
  end

  def edit; end

  def update
    if @ad.update(ad_params)
      flash[:notice] = 'Ad updated successfully.'
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
    redirect_to ads_path
  end

  def toggle_archived
    if @ad.toggle_archived_status
      flash[:notice] = "Ad #{@ad.archived ? 'unpublished' : 'published'} successfully."
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
