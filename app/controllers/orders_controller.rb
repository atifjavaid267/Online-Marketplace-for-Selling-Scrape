class OrdersController < ApplicationController
  load_and_authorize_resource

  before_action :store_location, only: %i[new]

  def new
    @order.bid_id = params[:bid_id]
  end

  def create
    # byebug
    if @order.save
      @order.bid.successful!
      @order.bid.ad.unpublished!
      redirect_to @order, notice: 'New Order Opened.'
    else
      redirect_to stored_location, notice: "Pickup time can't be blank"
    end
  end

  def show
    @address = Address.find(@order.bid.ad.address_id)
    @lati = @address.latitude
    @longi = @address.longitude
    @buyer = User.find(@order.bid.user_id)
    @seller = User.find(@order.bid.ad.user_id)
    @amount = @order.bid.price
  end

  def index
    @orders = @orders.paginate(page: params[:page], per_page: 10)
  end

  def show_pending
    @orders = @orders.pending.paginate(page: params[:page], per_page: 10)
  end

  def show_successful
    @orders = @orders.successful.paginate(page: params[:page], per_page: 10)
  end

  def show_cancelled
    @orders = @orders.cancelled.paginate(page: params[:page], per_page: 10)
  end

  def confirm
    @order.update_attribute(:status, 'successful')

    ad = @order.bid.ad
    ad.bids.each do |bid|
      next if bid.id == @order.bid.id

      bid.failed!
    end

    redirect_to @order
  end

  def cancel
    @order.update_attribute(:status, 'cancelled')
    @order.bid.failed!
    @order.bid.ad.published!

    redirect_to @order
  end

  private

  def order_params
    params.require(:order).permit(:bid_id, :pickup_time, :status)
  end
end
