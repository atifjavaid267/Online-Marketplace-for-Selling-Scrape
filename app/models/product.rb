# frozen_string_literal: true

class Product < ApplicationRecord
  include Sortable
  belongs_to :user
  has_many :ads, dependent: :restrict_with_error
  has_one_attached :product_image

  validates :product_image, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates :name, presence: true
  validates :description, presence: true

  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }
end
