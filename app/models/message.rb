class Message < ApplicationRecord
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :order

  def self.unread_message_count(sender_id, receiver_id)
    where(receiver_id:, sender_id:, read_at: nil).count
  end


  # def self.retrieve_messages(first_id, second_id)
  #   where("(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
  #         first_id, second_id, second_id, first_id)
  # end
end
