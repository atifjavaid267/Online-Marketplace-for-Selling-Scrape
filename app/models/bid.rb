class Bid < ApplicationRecord
  include Sortable
  belongs_to :ad
  belongs_to :user
  has_one :order
  validates :price, numericality: { greater_than_or_equal_to: 1 }

  enum status: { pending: 0, successful: 1, failed: 2 }

  scope :sort_by_price, ->(order) { order(price: order) }
  scope :all_except, ->(bid) { where.not(id: bid.id) }

  def self.fail!
    update(status: 'failed')
  end
end
