# app/services/message_broadcaster.rb
class MessageBroadcaster
  def initialize(message, order)
    @order = order
    @message = message
    @sender_id = message.sender_id
    @receiver_id = message.receiver_id
  end

  def broadcast_notifications
    count = Notification.notification_count(@sender_id, @receiver_id)

    ActionCable.server.broadcast("notifications_#{@receiver_id}", {
                                   total: count,
                                   sender_name: @message.first_name,
                                   message: @message.content,
                                   sender_id: @sender_id,
                                   receiver_id: @receiver_id,
                                   order_id: @order.id,
                                   timestamp: Time.zone.now.strftime('%B %d, %Y %I:%M %p')
                                 })
  end

  def broadcast_room_channel
    ActionCable.server.broadcast('room_channel_1', {
                                   sender_name: @message.first_name,
                                   message: @message.content,
                                   sender_id: @sender_id,
                                   receiver_id: @receiver_id,
                                   order_id: @order.id,
                                   timestamp: Time.zone.now.strftime('%I:%M %p')
                                 })
  end
end
