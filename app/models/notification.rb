class Notification < ApplicationRecord
  # belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  # belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  def self.already_existing(sender_id, receiver_id)
    notification = Notification.where(sender_id:, receiver_id:).first
    if notification.nil?
      nil
    else
      notification
    end
  end
end
