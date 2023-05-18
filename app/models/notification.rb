class Notification < ApplicationRecord
  def self.already_existing(sender_id, receiver_id)
    Notification.find_by(sender_id:, receiver_id:)
  end
end
