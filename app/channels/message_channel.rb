class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_channel_#{params[:room_id]}"
  end

  def unsubscribed; end
end
