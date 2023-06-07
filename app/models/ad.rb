# frozen_string_literal: true

class Ad < ApplicationRecord
  has_many_attached :ad_images
  has_many :bids, dependent: :restrict_with_error
  belongs_to :product
  belongs_to :user
  belongs_to :address

  validates :ad_images, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
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
end
