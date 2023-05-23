class Order < ApplicationRecord
  belongs_to :bid
  has_many :messages

  after_create :change_bids_status_for_create_order
  after_update :change_bids_status_for_confirm_order, if: :successful?
  after_update :change_bids_status_for_cancel_order, if: :cancelled?
  validates :pickup_time, presence: true
  validate :pickup_time_cannot_be_in_the_past

  scope :status, ->(status_param) { where(status: status_param) }

  scope :pending, -> { where(status: 'pending') }
  scope :successful, -> { where(status: 'successful') }
  scope :cancelled, -> { where(status: 'cancelled') }

  def pending?
    status == 'pending' # status enum
  end

  def successful?
    status == 'successful'
  end

  def cancelled?
    status == 'cancelled'
  end

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
    #  ad.bids.where.not(id: bid.id).update_all(status: 'failed', price: -1)
    ad.bids.where.not(id: bid.id).update_all(status: 'failed')
  end

  def change_bids_status_for_cancel_order
    bid.failed!
    bid.ad.published!
  end
end
