class Order < ApplicationRecord
  belongs_to :bid

  # validations
  validates :pickup_time, presence: true

  def pending?
    status == 'pending'
  end

  def successful?
    status == 'successful'
  end

  def cancelled?
    status == 'cancelled'
  end

end
