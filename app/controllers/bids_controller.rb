# frozen_string_literal: true

# Bids Controller
class BidsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :store_location, only: %i[new]

  def new
    @bid.user_id = current_user.id
    @bid.ad_id = params[:ad_id]
  end

  def create
    @bid.user_id = current_user.id

    if @bid.save
      respond_to do |format|
        flash[:notice] = 'Bid was created successfully.'
        ActionCable.server.broadcast('bids_channel',
                                     { ad_id: @bid.ad_id, price: @bid.price, buyer_id: @bid.user_id,
                                       buyer_name: @bid.user.first_name })
        format.json { render :show, status: :created, location: @bid }
        format.html { redirect_to buyer_home_path }
      end
    else
      flash[:alert] = @bid.errors.full_messages.join(', ')
      redirect_to stored_location
    end
  end

  def index
    @bids = @bids.paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
  end

  def view_bids
    @bids = @ad.bids.paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
  end

  private

  def bid_params
    params.require(:bid).permit(:ad_id, :price)
  end
end
