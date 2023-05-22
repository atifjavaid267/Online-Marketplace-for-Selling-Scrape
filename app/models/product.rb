class Product < ApplicationRecord
  has_one_attached :product_image
  has_many :ads
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  scope :published, -> { where(status: true) }
  scope :unpublished, -> { where(status: false) }

  private

  def check_associated_ads
    return unless ads.any?

    errors.add(:base, 'Ads associated with product, cannot be destroyed')
    throw(:abort)
  end
end
