class Product < ApplicationRecord
  has_one_attached :product_image
  has_many :ads
end
