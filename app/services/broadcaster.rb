# app/services/broadcaster.rb
class Broadcaster
  def initialize(message, order)
    @order = order
    @message = message
    @sender_id = message.sender_id
    @receiver_id = message.receiver_id
  end

  def call(name)
    case name
    when 'notification'
      channel_name = "notifications_#{@receiver_id}"
      total = Notification.notification_count(@sender_id, @receiver_id)
      time = Time.zone.now.strftime('%B %d, %Y %I:%M %p')
    when 'message'
      channel_name = 'message_channel_1'
      time = Time.zone.now.strftime('%I:%M %p')
    end

    ActionCable.server.broadcast(channel_name, {
                                   total:,
                                   sender_name: @message.first_name,
                                   message: @message.content,
                                   sender_id: @sender_id,
                                   receiver_id: @receiver_id,
                                   order_id: @order.id,
                                   timestamp: time
                                 })
  end
end
