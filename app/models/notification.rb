# frozen_string_literal: true

class Notification < ApplicationRecord
  def self.find_or_create_notification(sender_id, receiver_id)
    Notification.find_or_create_by(sender_id:, receiver_id:)
  end

  def increment_total
    update(total: total + 1)
  end

  def total_notifications
    total
  end

  def self.clear_notifications(current_user_id, buyer_id, seller_id)
    sender_id = current_user_id == seller_id ? buyer_id : seller_id
    notification = find_by(receiver_id: current_user_id, sender_id:)
    notification.update(total: 0) if notification && notification.total > 0
  end
end
