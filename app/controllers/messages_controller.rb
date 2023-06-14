# frozen_string_literal: true

# Message Controller
class MessagesController < ApplicationController
  load_and_authorize_resource :order, only: %i[new create]
  load_and_authorize_resource through: :order, only: %i[new create]
  load_and_authorize_resource except: %i[new create]

  before_action :clear_order_notifications, only: %i[new]

  def show; end

  def new
    @messages = @order.messages
  end

  def create
    @message.sender_id = current_user.id
    @message.receiver_id = current_user.seller? ? @order.buyer_id : @order.seller_id
    return if @message.save

    flash[:alert] = @message.errors.full_messages.join(', ')
    redirect_to new_order_message_path(@order)
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content)
  end

  def clear_order_notifications
    current_user.received_notifications.by_order(@order.id).each do |notification|
      notification.clear_total
    end
  end
end
