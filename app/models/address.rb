class Address < ApplicationRecord
  has_many :ads
  belongs_to :user
  # geocoded_by :city
  geocoded_by :full_address
  after_validation :geocode, if: lambda { |obj|
 obj.street1.present? || obj.street2.present? || obj.city.present? || obj.state.present? || obj.zip_code.present?
                                 }

  def latitude
    super || 0.0
  end

  def longitude
    super || 0.0
  end
  # validations
  validates :user_id, presence: true
  validates :city, presence: true
  validates :state, presence: true
  # validates :zip_code, presence: true
  validates :latitude, presence: true

  # for deocoder
  # after_validation :geocode
  def full_address
    [street1, street2, city, state, zip_code].compact.join(',')
  end

  # def validate_address
  #   # Check if the address is valid
  #   errors.add(:full_address, 'is invalid') unless Geocoder.search(full_address).first
  # end
end
