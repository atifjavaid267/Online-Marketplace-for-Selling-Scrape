class Bid < ApplicationRecord
  # associations
  belongs_to :ad
  belongs_to :user
  has_one    :order

  # validations
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1 } # 'Bid amount should be a positive integer!'

  def successful!
    update_attribute(:status, 'successful')
  end

  def failed!
    update_attribute(:status, 'failed')
  end

  # scopes
  scope :pending, -> { where(status: 'pending') }
end
