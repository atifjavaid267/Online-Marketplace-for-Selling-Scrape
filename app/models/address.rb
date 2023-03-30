class Address < ApplicationRecord
  has_many :ads
  belongs_to :user

  # validations
  # validates :user_id, presence: true
end
