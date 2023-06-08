# frozen_string_literal: true

class Notification < ApplicationRecord
  def self.notification_count(sender_id, receiver_id)
    notification = Notification.find_or_initialize_by(sender_id:, receiver_id:)
    if notification.new_record?
      notification.save
    else
<<<<<<< Updated upstream
      notification.update(read: false, count: notification.count + 1)
=======
      notification.update(read: false, total: notification.total + 1)
>>>>>>> Stashed changes
    end
    notification.total
  end

  def self.update_notifications(current_user, sender_id)
    notification = find_by(receiver_id: current_user.id, sender_id:)
    notification.update(total: 0, read: true) if notification && notification.total > 0
  end
end
