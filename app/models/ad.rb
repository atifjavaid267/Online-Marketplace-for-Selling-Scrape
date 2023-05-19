class Ad < ApplicationRecord
  has_many_attached :ad_images
  has_many :bids
  belongs_to :product
  belongs_to :user
  belongs_to :address

  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :address_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1 }
  validates :description, presence: true
  validates :ad_images, presence: true

  before_destroy :check_associated_bids

  scope :published, -> { where(status: true) }
  scope :unpublished, -> { where(status: false) }

  def published!
    update_attribute(:status, true)
  end

  def unpublished!
    update_attribute(:status, false)
  end

  private

  def check_associated_bids
    return unless bids.any?

    errors.add(:base, 'There are bids, Ad cannot be destroyed')
    throw(:abort)
  end
end
