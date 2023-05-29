
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
end