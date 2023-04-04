class BidsController < ApplicationController
  def new
    @ad = Ad.find(params[:ad_id])
    @bid = @ad.bids.new
    @bid.user_id = current_user.id
  end

  def create
    @ad = Ad.find(params[:ad_id])
    @bid = @ad.bids.build(bid_params)
    @bid.user_id = current_user.id

    if @bid.save
      redirect_to ads_path, notice: 'Ad was successfully created.'
    else
      # render :new
      redirect_to new_ad_bid_path(@ad)
    end
  end

  def view_bids
    @ad = Ad.find(params[:ad_id])
    @bids = @ad.bids
  end

  private

  def bid_params
    params.require(:bid).permit(:ad_id, :price)
  end
end
