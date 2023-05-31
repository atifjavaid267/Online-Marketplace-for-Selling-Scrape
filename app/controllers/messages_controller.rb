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
    @second_id = current_user.buyer? ? @order.seller_id : @order.buyer_id

    notification = Notification.where(receiver_id: current_user.id, sender_id: @second_id).first
    if notification
      notification.count = 0
      notification.read = true
      notification.save
    end

    @messages = Message.where(
      '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)', current_user.id, @second_id, @second_id, current_user.id
    )
  end

  def create
    @message.sender_id = current_user.id
    @message.receiver_id = current_user.seller? ? @order.buyer_id : @order.seller_id
    return unless @message.save

    sender_id = @message.sender_id
    receiver_id = @message.receiver_id
    message_content = @message.content
    sender_name = User.find(sender_id).first_name

    count = Notification.new_notification(sender_id, receiver_id)

    ActionCable.server.broadcast("notifications_#{receiver_id}", {
                                   count:,
                                   read: false,
                                   message: message_content,
                                   sender_name:,
                                   sender_id:,
                                   receiver_id:,
                                   order_id: @order.id,
                                   timestamp: Time.zone.now.strftime('%B %d, %Y %I:%M %p')
                                 })

    ActionCable.server.broadcast('room_channel_1', {
                                   sender_id:,
                                   receiver_id:,
                                   sender_name:,
                                   message: message_content,
                                   order_id: @order.id,
                                   timestamp: Time.zone.now.strftime('%I:%M %p')
                                 })
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content)
  end
end
