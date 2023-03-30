class Bid < ApplicationRecord

  # associations
  belongs_to :ad
  belongs_to :user

  # validations
  validates :price, presence: true

end
