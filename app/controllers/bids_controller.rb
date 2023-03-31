class BidsController < ApplicationController

  def new
    if current_user.buyer?
      @ad = Ad.find(params[:ad_id])
      @bid = @ad.bids.new
      @bid.user_id = current_user.id
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def create
    if current_user.buyer?
      @ad = Ad.find(params[:ad_id])
      @bid = @ad.bids.build(bid_params)
      @bid.user_id = current_user.id

      if @bid.save
        redirect_to ads_path, notice: "Ad was successfully created."
      else
        # render :new
        redirect_to new_ad_bid_path(@ad)
      end
    end
  end


  def view_bids
    if current_user.seller?
      @ad = Ad.find(params[:ad_id])
      @bids = @ad.bids
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
  private

  def bid_params
    params.require(:bid).permit(:ad_id, :price)
  end

end
