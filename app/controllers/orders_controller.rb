# frozen_string_literal: true

# Order Controller
class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :store_location, only: %i[new]

  def new
    @order.bid_id = params[:bid_id]
  end

  def create
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
    @orders = @orders.paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
  end

  def show_pending
    @orders = @orders.pending.paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
  end

  def show_successful
    @orders = @orders.successful.paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
  end

  def show_cancelled
    @orders = @orders.cancelled.paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
  end

  def confirm
    if @order.update_attribute(:status, 'successful')
      flash[:notice] = 'Order Completed.'
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to @order
  end

  def cancel
    if @order.update_attribute(:status, 'cancelled')
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
