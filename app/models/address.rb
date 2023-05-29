class Address < ApplicationRecord
  has_many :ads
  belongs_to :user

  geocoded_by :complete_address
  validates :user_id, presence: true

  before_destroy :check_associated_ads
  before_save :check_coordinates

  after_validation :geocode, if: lambda { |obj|
    obj.street1.present? || obj.street2.present? || obj.city.present? || obj.state.present? || obj.zip_code.present? || obj.full_address.present?
  }

  def complete_address
    [city, state, zip_code].compact.join(',')
  end

  private

  def check_coordinates
    return if latitude.present? && longitude.present?

    geocode_address
    throw(:abort) if latitude.nil? || longitude.nil?
  end

  def geocode_address
    geocode_result = Geocoder.search(complete_address).first
    if geocode_result.present?
      self.latitude = geocode_result.latitude
      self.longitude = geocode_result.longitude
    else
      errors.add(:base, 'Address was not found')
    end
  end

  def check_associated_ads
    return unless ads.any?

    errors.add(:base, 'Ads associated with address, cannot be destroyed')
    throw(:abort)
  end
end

