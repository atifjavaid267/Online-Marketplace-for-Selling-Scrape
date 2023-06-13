# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :order
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  def increment_total
    update(total: total + 1)
  end

  def clear_total
    update(total: 0)
  end

  scope :unread, -> { where.not(total: 0) }
  scope :by_order, ->(order_id) { where(order_id:) }
  scope :by_sender, ->(sender_id) { where(sender_id:) }
  scope :by_receiver, ->(receiver_id) { where(receiver_id:) }
end
