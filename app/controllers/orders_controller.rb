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
      @order.bid.successful!
      @order.bid.ad.unpublished!
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
    if current_user.admin?
      @orders = Order.all.paginate(page: params[:page], per_page: 5)
    elsif current_user.seller?
      @orders = Order.all.paginate(page: params[:page], per_page: 5)#.joins(:bids, :ads).where(ads: {user_id: current_user.id})
    elsif current_user.buyer?
      @orders = Order.all.paginate(page: params[:page], per_page: 5)#joins(:bids).where(bids: {user_id: current_user.id})
    end
  end

  def show_pending
    if current_user.admin?
      @orders = Order.where(status: 'pending')
    elsif current_user.seller?
      @orders = Order.where(status: 'pending')
    end
  end

  def show_successful
    if current_user.admin?
      @orders = Order.where(status: 'successful')
    elsif current_user.seller?
      @orders = Order.where(status: 'successful')
    end
  end

  def show_cancelled
    if current_user.admin?
      @orders = Order.where(status: 'cancelled')
    elsif current_user.seller?
      @orders = Order.where(status: 'cancelled')
    end
  end

  def confirm
    @order = Order.find(params[:id])
    @order.update_attribute(:status, 'successful')
    ad = @order.bid.ad
    ad.bids.each do |bid|
      bid.failed!
    end
    @order.bid.successful!
    redirect_to @order
  end

  def cancel
    @order = Order.find(params[:id])
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
