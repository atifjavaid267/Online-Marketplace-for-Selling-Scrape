class Notification < ApplicationRecord
  def self.already_existing(sender_id, receiver_id)
    notification = Notification.find_by(sender_id:, receiver_id:)
    if notification.nil?
      notification = Notification.create(sender_id:, receiver_id:)
    else
      count = notification.count + 1
      notification.update(count:, read: false)
    end
    notification.count
  end
end
