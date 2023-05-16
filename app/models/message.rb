class Message < ApplicationRecord
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  def notifications
    Notification.where(sender_id: self.sender_id, receiver_id: self.receiver_id)
  end
end
