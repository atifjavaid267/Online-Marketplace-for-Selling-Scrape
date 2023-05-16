class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # def send_notification(data)
  #   receiver_id = data['receiver_id']
  #   notification = Notification.create!(sender_id: current_user.id, receiver_id:)

  #   ActionCable.server.broadcast("notifications_#{receiver_id}", { notification: })
  # end
end
