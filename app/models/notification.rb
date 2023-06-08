# frozen_string_literal: true

class Notification < ApplicationRecord
  def self.notification_count(sender_id, receiver_id)
    notification = Notification.find_or_initialize_by(sender_id:, receiver_id:)
    if notification.new_record?
      notification.save
    else
      notification.update(total: notification.total + 1)
    end
    notification.total
  end

  def self.update_notifications(current_user_id, buyer_id, seller_id)
    sender_id = current_user_id == seller_id ? buyer_id : seller_id

    notification = find_by(receiver_id: current_user_id, sender_id:)
    notification.update(total: 0) if notification && notification.total > 0
  end
end
