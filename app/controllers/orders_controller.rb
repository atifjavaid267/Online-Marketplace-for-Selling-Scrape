class OrdersController < ApplicationController
  def new
    @bid = Bid.find(params[:bid_id])
    @order = @bid.build_order

    @order.bid_id = @bid.id
  end

  def create
    @bid = Bid.find(params[:bid_id])
    @order = @bid.build_order(order_params)

    @order.bid_id = @bid.id

    if @order.save
      redirect_to @order, notice: 'New Order Opened.'
    else
      redirect_to new_bid_order_path(@bid), notice: 'Please select date and time.'
    end
  end

  def show
    @order = Order.find(params[:id])
    @address = Address.find(@order.bid.ad.address_id)
    # @seller_id = @order.bid.ad.user_id
    # @buyer_id = @order.bid.user_id

    @buyer = User.find(@order.bid.user_id)
    @seller = User.find(@order.bid.ad.user_id)
    @amount = @order.bid.price
  end

  def index
    @order = Order.find(params[:id])
  end

  def pending_orders
    if current_user.admin?
      @orders = Order.where(status: 'pending')
    elsif current_user.seller?
      @orders = Order.where(status: 'pending')
    end
  end

  def successful_orders
    if current_user.admin?
      @orders = Order.where(status: 'successful')
    elsif current_user.seller?
      @orders = Order.where(status: 'successful')
    end
  end

  def cancelled_orders
    if current_user.admin?
      @orders = Order.where(status: 'cancelled')
    elsif current_user.seller?
      @orders = Order.where(status: 'cancelled')
    end
  end

  def confirm
    @order = Order.find(params[:id])
    @order.update_attribute(:status, 'successful')

    # @ad = @order.bid.ad
    # @bids = Bid.where(ad_id: @ad.id)
    # @bids.each do |bid|
    #   next if bid_id == @order.bid_id
    #   bid.status = "failed"
    # end

    redirect_to @order
  end

  def cancel
    @order = Order.find(params[:id])
    @order.update_attribute(:status, 'cancelled')
    redirect_to @order
  end

  private

  def order_params
    params.require(:order).permit(:bid_id, :pickup_time, :status)
  end
end
