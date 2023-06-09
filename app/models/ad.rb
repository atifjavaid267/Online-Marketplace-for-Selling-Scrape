# frozen_string_literal: true

class Ad < ApplicationRecord
  has_many_attached :ad_images
  has_many :bids, dependent: :restrict_with_error
  belongs_to :product
  belongs_to :user
  belongs_to :address

  validate :images_type
  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :address_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1 }
  validates :description, presence: true
  validates :ad_images, presence: true

  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }

  def published!
    update(archived: false)
  end

  def unpublished!
    update(archived: true)
  end

  def toggle_archived_status
    update(archived: !archived)
  end

  private

  def images_type
    return unless ad_images.attached?

    ad_images.each do |image|
      unless image.content_type.in?(%w[image/png image/jpeg image/jpg])
        errors.add(:ad_images, 'must be jpg, jpeg or png files.')
      end
    end
  end
end
