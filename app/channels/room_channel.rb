class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params[:room_id]}"
  end

  def unsubscribed; end

  def speak(data)
    message = Message.create!(sender_id: data['sender_id'], receiver_id: data['receiver_id'],
                              content: data['message'],  order_id: data['order_id'], timestamp: Time.zone.now.strftime('%I:%M %p'))
    html = render_to_string(partial: 'messages/message', locals: { message: })
    ActionCable.server.broadcast "room_channel_#{params[:room_id]}", html:,
                                                                     content: message.content
  end

  def render_message(message)
    ApplicationController.render.render(partial: 'messages/message', locals: { message: })
  end
end
