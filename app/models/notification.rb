# frozen_string_literal: true

class Notification < ApplicationRecord
  def self.find_notification_and_get_count(sender_id, receiver_id)
    notification = Notification.find_or_create_by(sender_id:, receiver_id:)
    notification.update(total: notification.total + 1)
    notification.total
  end

  def self.update_notifications(current_user_id, buyer_id, seller_id)
    sender_id = current_user_id == seller_id ? buyer_id : seller_id
    notification = find_by(receiver_id: current_user_id, sender_id:)
    notification.update(total: 0) if notification && notification.total > 0
  end
end
