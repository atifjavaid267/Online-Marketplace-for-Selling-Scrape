class Product < ApplicationRecord
  has_one_attached :product_image
  has_many :ads, dependent: :restrict_with_error
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true

  scope :published, -> { where(status: true) }
  scope :unpublished, -> { where(status: false) }
end
