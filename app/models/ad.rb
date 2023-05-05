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
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :description, presence: true
  validates :ad_images, presence: true

  def published!
    update_attribute(:status, true)
  end

  def unpublished!
    update_attribute(:status, false)
  end
end
