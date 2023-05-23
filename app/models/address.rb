class Address < ApplicationRecord
  has_many :ads, dependent: :restrict_with_error
  belongs_to :user
  geocoded_by :full_address
  validates :user_id, presence: true
  validates :city, presence: true
  validates :state, presence: true
  before_save :geocode
  before_save :check_coordinates

  after_validation :geocode, if: lambda { |obj|
    obj.street1.present? || obj.street2.present? || obj.city.present? || obj.state.present? || obj.zip_code.present?
  }

  def latitude
    super || 0.0
  end

  def longitude
    super || 0.0
  end

  def full_address
    [street1, street2, city, state, zip_code].compact.join(',')
  end

  private

  def check_coordinates
    return unless latitude.zero? && longitude.zero?

    errors.add(:base, 'Address was not found')
    throw(:abort)
  end
end
