# app/services/message_broadcaster.rb
class MessageBroadcaster
  def initialize(message, order)
    @message = message
    @order = order
  end

  def broadcast_notifications
    sender_id = @message.sender_id
    receiver_id = @message.receiver_id
    message_content = @message.content
    sender_name = @message.first_name

    count = Notification.new_notification(sender_id, receiver_id)

    ActionCable.server.broadcast("notifications_#{receiver_id}", {
      count: count,
      read: false,
      message: message_content,
      sender_name: sender_name,
      sender_id: sender_id,
      receiver_id: receiver_id,
      order_id: @order.id,
      timestamp: Time.zone.now.strftime('%B %d, %Y %I:%M %p')
    })
  end

  def broadcast_room_channel
    sender_id = @message.sender_id
    receiver_id = @message.receiver_id
    message_content = @message.content
    sender_name = @message.first_name

    ActionCable.server.broadcast('room_channel_1', {
      sender_id: sender_id,
      receiver_id: receiver_id,
      sender_name: sender_name,
      message: message_content,
      order_id: @order.id,
      timestamp: Time.zone.now.strftime('%I:%M %p')
    })
  end
end
