class Bid < ApplicationRecord
  include Sort
  belongs_to :ad
  belongs_to :user
  has_one :order

  validates :price, numericality: { greater_than_or_equal_to: 1 }

  scope :pending, -> { where(status: 'pending') }

  enum status: { pending: 0, successful: 1, failed: 2 }
end
