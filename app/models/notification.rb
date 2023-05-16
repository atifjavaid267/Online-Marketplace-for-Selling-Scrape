class Notification < ApplicationRecord
  def self.already_existing(sender_id, receiver_id)
    notification = Notification.where(sender_id:, receiver_id:).first
    if notification.nil?
      nil
    else
      notification
    end
  end
end
