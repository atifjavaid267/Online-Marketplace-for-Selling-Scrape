class Bid < ApplicationRecord

  # associations
  belongs_to :ad
  belongs_to :user
  has_one    :order
  # validations
  validates :price, presence: true

end
