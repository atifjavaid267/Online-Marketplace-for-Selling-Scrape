class Order < ApplicationRecord
  belongs_to :bid
  has_many :messages
  # validations
  validates :pickup_time, presence: true
  validate :pickup_time_cannot_be_in_the_past

  def pending?
    status == 'pending'
  end

  def successful?
    status == 'successful'
  end

  def cancelled?
    status == 'cancelled'
  end

  # scopes
  scope :pending, -> { where(status: 'pending') }
  scope :successful, -> { where(status: 'successful') }
  scope :cancelled, -> { where(status: 'cancelled') }

  private

  def pickup_time_cannot_be_in_the_past
    return unless pickup_time.present? && pickup_time < Time.now

    errors.add(:pickup_time, 'cannot be in the past')
  end
end
