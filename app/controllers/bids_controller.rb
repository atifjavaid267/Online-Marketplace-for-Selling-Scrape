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

    respond_to do |format|
      if @bid.save

        ActionCable.server.broadcast('bids_channel', { ad_id: @ad.id, price: @bid.price })
        format.json { render :show, status: :created, location: @bid }
        format.html { redirect_to ads_path, notice: 'Bid was successfully created.' }

      else
        format.html { redirect_to new_ad_bid_path(@ad) }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # def create
  #   @ad = Ad.find(params[:ad_id])
  #   @bid = @ad.bids.build(bid_params)
  #   @bid.user_id = current_user.id

  #   if @bid.save
  #     redirect_to ads_path, notice: 'Ad was successfully created.'
  #   else
  #     # render :new
  #     redirect_to new_ad_bid_path(@ad)
  #   end
  # end

  def view_bids
    @ad = Ad.find(params[:ad_id])
    @bids = @ad.bids
  end

  private

  def bid_params
    params.require(:bid).permit(:ad_id, :price)
  end
end
