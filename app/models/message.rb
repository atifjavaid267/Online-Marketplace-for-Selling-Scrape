# Message Model

class Message < ApplicationRecord
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :order

  def self.unread_message_count(sender_id, receiver_id)
    where(receiver_id:, sender_id:, read_at: nil).count
  end
end
