class MessageBroadcaster
  def self.call(message)
      ActionCable.server.broadcast("message_channel", {
                                     message: message.content,
                                     receiver_id: message.receiver_id,
                                     time: Time.zone.now.strftime('%I:%M %p')
                                   })
  end
end
