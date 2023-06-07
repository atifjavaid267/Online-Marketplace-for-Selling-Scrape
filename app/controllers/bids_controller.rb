# frozen_string_literal: true

# Bids Controller
class BidsController < ApplicationController
  load_and_authorize_resource :ad, only: %i[new create]
  load_and_authorize_resource through: :ad, only: %i[new create]
  load_and_authorize_resource except: %i[new create]
  before_action :authenticate_user!

  def new; end

  def create
    @bid.user_id = current_user.id

    if @bid.save
      flash[:notice] = 'Bid created successfully.'
      BidBroadcast.broadcast_bid(@bid)
      redirect_to stored_location
    else
      flash[:alert] = @bid.errors.full_messages.join(', ')
      render :new
    end
  end

  def index
    @bids = @bids.includes([ad: :product]).recently_updated.page(params[:page])
  end

  private

  def bid_params
    params.require(:bid).permit(:ad_id, :price)
  end
end
