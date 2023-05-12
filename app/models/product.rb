class Product < ApplicationRecord
  has_one_attached :product_image
  has_many :ads

  # validation
  validates :name, presence: true
  validates :description, presence: true
  validates :product_image, presence: true

  # callbacks
  before_destroy :check_associated_ads

  # scopes
  scope :published, -> { where(status: true) }
  scope :unpublished, -> { where(status: false) }

  private

  def check_associated_ads
    return unless Ad.where(product_id: id).any?

    errors.add(:base, 'Ads associated with product, cannot be destroyed')
    throw(:abort)
  end
end
