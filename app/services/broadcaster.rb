# app/services/broadcaster.rb
class Broadcaster
  def initialize(message)
    @order_id = message.order_id
    @message = message
    @sender_id = message.sender_id
    @receiver_id = message.receiver_id
  end

  def call(name)
    case name
    when 'notification'
      channel_name = "notification_#{@receiver_id}"
      notification = Notification.find_or_create_by(order_id: @order_id, sender_id: @sender_id,
                                                    receiver_id: @receiver_id)
      notification.increment_total

      receiver_notifications = @message.receiver.received_notifications.unread
      notifications = {}
      receiver_notifications.each do |n|
        notifications[n.order_id] = [n.sender.first_name, n.total]
      end

      time = Time.zone.now.strftime('%B %d, %Y %I:%M %p')
    when 'message'
      channel_name = 'message_channel'
      time = Time.zone.now.strftime('%I:%M %p')
    end

    ActionCable.server.broadcast(channel_name, {
                                   notifications:,
                                   message: @message.content,
                                   receiver_id: @receiver_id,
                                   #  order_id: @order_id,
                                   timestamp: time
                                 })
  end
end
