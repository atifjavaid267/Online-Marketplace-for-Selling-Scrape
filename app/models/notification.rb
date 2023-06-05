# class Notification
class Notification < ApplicationRecord
  def self.new_notification(sender_id, receiver_id)
    notification = Notification.find_or_initialize_by(sender_id:, receiver_id:)
    if notification.new_record?
      notification.save
    else
      notification.increment!(:count)
      notification.update(read: false)
    end
    notification.count
  end

  def self.update_notifications_and_get_messages(current_user, sender_id)
    notification = find_by(receiver_id: current_user.id, sender_id:)
    notification.update(count: 0, read: true) if notification

    messages = Message.where(sender_id: [current_user.id, sender_id],
                             receiver_id: [current_user.id,
                                           sender_id])

    [notification, messages]
  end
end