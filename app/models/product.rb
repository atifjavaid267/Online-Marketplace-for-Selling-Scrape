class Product < ApplicationRecord
  has_one_attached :product_image
  has_many :ads

  # validation
  validates :name, presence: true
  validates :description, presence: true
  validates :product_image, presence: true

  # scopes
  scope :published, -> { where(status: true) }
  scope :unpublished, -> { where(status: false) }
end
