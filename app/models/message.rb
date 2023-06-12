# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :order
  delegate :first_name, to: :sender
  after_save :broadcast

  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  private

  def broadcast
    broadcaster = Broadcaster.new(self)
    broadcaster.call('notification')
    broadcaster.call('message')
  end
end
