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
end
