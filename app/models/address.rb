class Address < ApplicationRecord
  has_many :ads
  belongs_to :user

  # validations
  validates :user_id, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true


  # for deocoder
  # after_validation :geocode

end
