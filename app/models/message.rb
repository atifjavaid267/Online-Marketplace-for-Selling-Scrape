# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :order
  delegate :first_name, to: :sender

  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  def self.unread_message_count(sender_id, receiver_id)
    where(receiver_id:, sender_id:, read_at: nil).count
  end

  def self.messages(current_user, sender_id)
    where(sender_id: [current_user, sender_id], receiver_id: [current_user, sender_id])
  end
end
