# app/services/broadcaster.rb
class NotificationBroadcaster
  def self.call(message)
        notification = Notification.find_or_create_by(order_id: message.order_id, sender_id: message.sender_id,
                                                      receiver_id: message.receiver_id)
        notification.increment_total

        receiver_notifications = message.receiver.received_notifications.unread
        notifications = {}
        receiver_notifications.each do |n|
          notifications[n.order_id] = [n.sender.first_name, n.total]
        end

        ActionCable.server.broadcast("notification_#{message.receiver_id}", {
                                       notifications:
                                     })
  end
end
