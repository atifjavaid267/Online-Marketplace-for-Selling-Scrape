# frozen_string_literal: true

class Order < ApplicationRecord
  include Sortable
  belongs_to :bid
  has_many :messages
  has_many :notifications
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'

  validates :pickup_time, presence: true
  validate :pickup_time_cannot_be_in_the_past

  after_save :update_bids_and_ad_status

  enum status: { pending: 0, successful: 1, cancelled: 2 }

  private

  def pickup_time_cannot_be_in_the_past
    return unless pickup_time.present? && pickup_time < Time.zone.now

    errors.add(:pickup_time, 'cannot be in the past')
  end

  def update_bids_and_ad_status
    if pending?
      bid.successful!
      bid.ad.unpublished!
    elsif cancelled?
      bid.failed!
      bid.ad.published!
    elsif successful?
      bid.ad.bids.all_except(bid).failed
    end
  rescue StandardError => e
    logger.error(e.to_s)
  end
end
