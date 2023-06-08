# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :order
  delegate :first_name, to: :sender
  after_save :broadcast

  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  def self.messages(current_user, sender_id)
    where(sender_id: [current_user, sender_id], receiver_id: [current_user, sender_id])
  end

  private

  def broadcast
    MessageBroadcaster.new(self, order).broadcast_notifications
    MessageBroadcaster.new(self, order).broadcast_room_channel
  end
end
