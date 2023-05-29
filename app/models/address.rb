class Address < ApplicationRecord
  has_many :ads, dependent: :restrict_with_error
  belongs_to :user

  geocoded_by :complete_address
  validates :user_id, presence: true
  before_save :check_coordinates

  scope :recently_updated, -> { order(updated_at: :desc) }

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
end
