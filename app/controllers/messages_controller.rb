# frozen_string_literal: true

# Message Controller
class MessagesController < ApplicationController
  load_and_authorize_resource :order, only: %i[new create]
  load_and_authorize_resource through: :order, only: %i[new create]
  load_and_authorize_resource except: %i[new create]
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show; end

  def new
    @sender_id = current_user.buyer? ? @order.seller_id : @order.buyer_id
    @notification = Notification.update_notifications(current_user, @sender_id)
    @messages = Message.messages(@current_user, @sender_id)
  end

  def create
    @message.sender_id = current_user.id
    @message.receiver_id = current_user.seller? ? @order.buyer_id : @order.seller_id
    return unless @message.save

    broadcaster = MessageBroadcaster.new(@message, @order)
    broadcaster.broadcast_notifications
    broadcaster.broadcast_room_channel
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content)
  end
end
