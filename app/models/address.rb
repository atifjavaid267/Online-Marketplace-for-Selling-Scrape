class Address < ApplicationRecord
  has_many :ads
  belongs_to :user

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
  validates :longitude, presence: true

  before_destroy :check_associated_ads

  # for geocoder
  # after_validation :geocode
  def full_address
    [street1, street2, city, state, zip_code].compact.join(',')
  end

  private

  def check_associated_ads
    return unless Ad.where(address_id: id).any?

    errors.add(:base, 'Ads associated with address, cannot be destroyed')
    throw(:abort)
  end
end
