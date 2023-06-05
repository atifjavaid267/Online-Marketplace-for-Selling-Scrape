# frozen_string_literal: true

# Order Controller
class OrdersController < ApplicationController
  load_and_authorize_resource :bid, only: %i[new create]
  load_and_authorize_resource :order, through: :bid, singleton: true, only: %i[new create]
  load_and_authorize_resource except: %i[new create]

  before_action :authenticate_user!
  before_action :store_location, only: %i[new]

  def new; end

  def create
    @order.buyer_id = @bid.user_id
    @order.seller_id = @bid.ad.user_id
    if @order.save
      flash[:notice] = 'New Order Opened.'
      redirect_to @order
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
      redirect_to stored_location
    end
  end

  def show; end

  def index
    case params[:status]
    when 'pending'
      @orders = @orders.pending
    when 'successful'
      @orders = @orders.successful
    when 'cancelled'
      @orders = @orders.cancelled
    end
    @orders = @orders.includes(%i[buyer seller]).recently_updated.page(params[:page])
  end

  def confirm
    if @order.update(status: 'successful')
      flash[:notice] = 'Order Completed.'
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to @order
  end

  def cancel
    if @order.update(status: 'cancelled')
      flash[:notice] = 'Order Cancelled.'
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to @order
  end

  private

  def order_params
    params.require(:order).permit(:bid_id, :pickup_time, :status)
  end
end
