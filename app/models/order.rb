class Order < ApplicationRecord
  include Sort
  belongs_to :bid
  has_many :messages

  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'

  after_create :change_bids_status_for_create_order
  after_update :change_bids_status_for_confirm_order, if: :successful?
  after_update :change_bids_status_for_cancel_order, if: :cancelled?
  validates :pickup_time, presence: true
  validate :pickup_time_cannot_be_in_the_past

  enum status: { pending: 0, successful: 1, cancelled: 2 }

  scope :status, ->(status_param) { where(status: status_param) }

  private

  def pickup_time_cannot_be_in_the_past
    return unless pickup_time.present? && pickup_time < Time.zone.now

    errors.add(:pickup_time, 'cannot be in the past')
  end

  def change_bids_status_for_create_order
    bid.successful!
    bid.ad.unpublished!
  end

  def change_bids_status_for_confirm_order
    ad = bid.ad
    ad.bids.where.not(id: bid.id).update(status: 'failed')
  end

  def change_bids_status_for_cancel_order
    bid.failed!
    bid.ad.published!
  end
end
