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
      channel_name = "notifications_#{@receiver_id}"
      notification = Notification.find_or_create_by(order_id: @order_id, sender_id: @sender_id,
                                                    receiver_id: @receiver_id)
      notification.increment_total

      current_user_notifications = @message.receiver.notifications.unread
      notifications = {}
      current_user_notifications.each do |n|
        notifications[n.sender.first_name] = n.total
      end

      time = Time.zone.now.strftime('%B %d, %Y %I:%M %p')
    when 'message'
      channel_name = 'message_channel'
      time = Time.zone.now.strftime('%I:%M %p')
    end

    ActionCable.server.broadcast(channel_name, {
                                   notifications:,
                                   sender_name: @message.first_name,
                                   message: @message.content,
                                   receiver_id: @receiver_id,
                                   order_id: @order_id,
                                   timestamp: time
                                 })
  end
end
