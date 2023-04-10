class Order < ApplicationRecord
  belongs_to :bid

  # validations
  validates :pickup_time, presence: true
  validate :pickup_time_cannot_be_in_the_past


  def pending?
    status == "pending"
  end

  def successful?
    status == "successful"
  end

  def cancelled?
    status == "cancelled"
  end

  private

  def pickup_time_cannot_be_in_the_past
    if pickup_time.present? && pickup_time < Time.now
      errors.add(:pickup_time, "can't be in the past")
    end
  end
end

