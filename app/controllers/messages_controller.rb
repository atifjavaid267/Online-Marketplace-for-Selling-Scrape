# frozen_string_literal: true

# Message Controller
class MessagesController < ApplicationController
  load_and_authorize_resource :order, only: %i[new create]
  load_and_authorize_resource through: :order, only: %i[new create]
  load_and_authorize_resource except: %i[new create]
  before_action :authenticate_user!

  def show; end

  def new
    @receiver_id = current_user.seller? ? @order.buyer_id : @order.seller_id
    @notification = Notification.update_notifications(current_user, @receiver_id)
    @messages = Message.your_messages([@current_user.id, @receiver_id])
  end

  def create
    @message.sender_id = current_user.id
    @message.receiver_id = current_user.seller? ? @order.buyer_id : @order.seller_id
    return if @message.save

    flash[:alert] = @message.errors.full_messages.join(', ')
    render :new
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content)
  end
end
