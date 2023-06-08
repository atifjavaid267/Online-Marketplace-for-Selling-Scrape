# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :order
  delegate :first_name, to: :sender
  after_save :broadcast

  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  scope :conversation_between, ->(user_ids) { where(sender_id: user_ids, receiver_id: user_ids) }

  private

  def broadcast
    MessageBroadcaster.new(self, order).broadcast_notifications
    MessageBroadcaster.new(self, order).broadcast_room_channel
  end
end
