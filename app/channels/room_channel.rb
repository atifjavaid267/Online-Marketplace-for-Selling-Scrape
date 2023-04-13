class RoomChannel < ApplicationCable::Channel
  def subscribed
     stream_from "room_channel_#{params[:room_id]}"
    #  load_messages
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    message = Message.create!(sender_id: data['sender_id'], receiver_id: data['receiver_id'],
                              content: data['message'])
    html = render_to_string(partial: 'messages/message', locals: { message: })
    ActionCable.server.broadcast "room_channel_#{params[:room_id]}", html:
  end
  # def speak(data)
  #   message = Message.create!(sender_id: data['sender_id'], receiver_id: data['receiver_id'],
  #                             content: data['message'])
  #   html = render_message(message)
  #   ActionCable.server.broadcast 'messages', html:
  # end

  private

  # def load_messages
  #   messages = Message.where(room_id: params[:room_id])
  #   html = ''

  #   messages.each do |message|
  #     html += render_to_string(partial: 'messages/message', locals: { message: })
  #   end
  #   ActionCable.server.broadcast "room_channel_#{params[:room_id]}", html:
  # end

  def render_message(message)
    ApplicationController.render.render(partial: 'messages/message', locals: { message: })
  end
end