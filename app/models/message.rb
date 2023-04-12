class Message < ApplicationRecord
  validates :sender_id, presence: true
end
