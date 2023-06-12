# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :notification

  def self.find_or_create_notification(sender_id, receiver_id)
    Notification.find_or_create_by(sender_id:, receiver_id:)
  end

  def increment_total
    update(total: total + 1)
  end
end
