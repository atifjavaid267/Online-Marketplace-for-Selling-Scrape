# frozen_string_literal: true

# Bids Controller
class BidsController < ApplicationController
  load_and_authorize_resource :ad, only: %i[new create]
  load_and_authorize_resource through: :ad, only: %i[new create]
  load_and_authorize_resource except: %i[new create]
  before_action :authenticate_user!
  before_action :store_location, only: %i[new show]

  def new; end

  def create
    @bid.user_id = current_user.id

    if @bid.save
      respond_to do |format|
        flash[:notice] = 'Bid was created successfully.'
        ActionCable.server.broadcast('bids_channel',
                                     { ad_id: @bid.ad_id, price: @bid.price, buyer_id: @bid.user_id,
                                       buyer_name: @bid.user.full_name })
        format.json { render :show, status: :created, location: @bid }
        format.html { redirect_to ads_path }
      end
    else
      flash[:alert] = @bid.errors.full_messages.join(', ')
      redirect_to stored_location
    end
  end

  def index
    @bids = @bids.order(created_at: :desc).paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
    @bids = @bids.includes([:ad])
  end

  private

  def bid_params
    params.require(:bid).permit(:ad_id, :price)
  end
end
