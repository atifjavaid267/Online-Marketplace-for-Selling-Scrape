class Notification < ApplicationRecord
  # def self.already_existing(sender_id, receiver_id)
  #   notification = Notification.where(sender_id:, receiver_id:).first
  #   if notification.nil?
  #     nil
  #   else
  #     notification
  #   end
  # end
  def self.already_existing(sender_id, receiver_id)
    Notification.find_by(sender_id:, receiver_id:)
  end
end
