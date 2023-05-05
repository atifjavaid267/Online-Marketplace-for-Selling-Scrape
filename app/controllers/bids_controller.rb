class BidsController < ApplicationController
  load_and_authorize_resource

  def new
    @ad = Ad.find(params[:ad_id])
    @bid = @ad.bids.new
    @bid.user_id = current_user.id
  end

  def create
    # byebug
    @ad = Ad.find(params[:ad_id])
    @bid = @ad.bids.build(bid_params)
    @bid.user_id = current_user.id

    if @bid.price.nil?
      redirect_to new_ad_bid_path(@ad), notice: 'Bid amount should be positive number!'
    elsif @bid.price.negative? || @bid.price.zero?
      redirect_to new_ad_bid_path(@ad), notice: 'Bid amount should be a positive integer!'
    elsif @bid.save
      redirect_to buyer_home_path, notice: 'Your bid submitted successfully.'
    else
      redirect_to new_ad_bid_path(@ad), notice: 'Please enter bid amount'
    end
  end

  def index
    @bids = Bid.all.where(user_id: current_user.id).paginate(page: params[:page], per_page: 10)
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
