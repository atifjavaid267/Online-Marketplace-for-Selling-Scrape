class Bid < ApplicationRecord

  # associations
  belongs_to :ad
  belongs_to :user
  has_one    :order

  # validations
  validates :price, presence: true

  def successful!
    update_attribute(:status, 'successful')
  end

  def failed!
    update_attribute(:status, 'failed')
  end

end
