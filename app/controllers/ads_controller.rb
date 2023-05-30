# frozen_string_literal: true

# Ads Controller
class AdsController < ApplicationController
  load_and_authorize_resource :product, only: %i[new create]
  load_and_authorize_resource through: :product, only: %i[new create]
  load_and_authorize_resource except: %i[new create]

  before_action :authenticate_user!
  before_action :store_location, only: %i[new index]

  def index
    @ads = @ads.archived(params[:archived] || false).paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
    @ads = @ads.includes([:product], [:ad_images_attachments])
  end

  def show; end

  def new
    @addresses = {}
    current_user.addresses.each do |a|
      @addresses[[a.street1, a.street2, a.city, a.state, a.zip_code].reject(&:nil?).reject(&:empty?).join(', ')] = a.id
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
    @bids = @ad.bids.pending.order(price: :desc).paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
    @bids = @bids.includes([:user])
  end

  def edit
    @addresses = {}
    current_user.addresses.each do |a|
      @addresses[[a.street1, a.street2, a.city, a.state, a.zip_code].reject(&:nil?).reject(&:empty?).join(', ')] = a.id
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

  def toggle_archived
    if @ad.update_attribute(:archived, !@ad.archived)
      flash[:notice] = @ad.archived ? 'Ad Unpublished' : 'Ad Published'
    else
      flash[:alert] = @ad.errors.full_messages.join(', ')
    end
    redirect_to ads_path(archived: false)
  end

  private

  def ad_params
    params.require(:ad).permit(:product_id, :price, :description, :address_id, ad_images: [])
  end
end
