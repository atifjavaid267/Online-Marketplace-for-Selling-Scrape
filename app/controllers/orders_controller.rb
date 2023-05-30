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
    @orders = @orders.status(params[:status]) if params[:status]
    @orders = @orders.includes(bid: { user: {}, ad: :user }).references(:users).recently_updated.paginate(
      page: params[:page], per_page: RECORDS_PER_PAGE
    )
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
