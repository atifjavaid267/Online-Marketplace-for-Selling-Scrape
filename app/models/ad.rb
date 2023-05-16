class Ad < ApplicationRecord
  # active stporage
  has_many_attached :ad_images

  # association
  belongs_to :product
  belongs_to :user

  has_one :address
  has_many :bids

  # validations
  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :address_id, presence: true
  validates :price, presence: { message: "Price can't be blank" },
                    numericality: { greater_than_or_equal_to: 1, message: 'Price cannot be negative or zero!' }

  validates :description, presence: true
  validates :ad_images, presence: true

  before_destroy :check_associated_bids

  def published!
    update_attribute(:status, true)
  end

  def unpublished!
    update_attribute(:status, false)
  end

  # scopes
  scope :published, -> { where(status: true) }
  scope :unpublished, -> { where(status: false) }

  private

  def check_associated_bids
    return unless Bid.where(ad_id: id).any?

    errors.add(:base, 'There are bids, Ad cannot be destroyed')
    throw(:abort)
  end
end
