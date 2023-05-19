class Bid < ApplicationRecord
  belongs_to :ad
  belongs_to :user
  has_one    :order

  validates :price, numericality: { greater_than_or_equal_to: 1 }

  scope :pending, -> { where(status: 'pending') }

  def successful!
    update_attribute(:status, 'successful')
  end

  def failed!
    update_attribute(:status, 'failed')
  end
end
