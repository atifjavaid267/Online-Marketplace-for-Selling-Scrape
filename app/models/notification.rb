# class Notification
class Notification < ApplicationRecord
  def self.notification_count(sender_id, receiver_id)
    notification = Notification.find_or_initialize_by(sender_id:, receiver_id:)
    if notification.new_record?
      notification.save
    else
      notification.update(read: false, count: count + 1)
    end
    notification.count
  end

  def self.update_notifications(current_user, sender_id)
    notification = find_by(receiver_id: current_user.id, sender_id:)
    notification.update(count: 0, read: true) if notification && notification.count > 0
  end
end
