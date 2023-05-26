class User < ApplicationRecord
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'

  devise :two_factor_authenticatable, otp_secret_encryption_key: ENV['encryption_key_env']
  devise :registerable, :recoverable, :rememberable, :validatable, :two_factor_authenticatable

  validates :phone_no, format: { with: /\A\+923|03\d{9}\z/ }
  validates :first_name, format: { with: /\A[a-zA-Z ]+\z/, message: 'only allows letters and spaces' }
  validates :last_name, format: { with: /\A[a-zA-Z ]+\z/, message: 'only allows letters and spaces' }
  validates :role, presence: true

  # ROLES = %w[admin seller buyer].freeze

  has_many :products
  has_many :ads
  has_many :addresses
  has_many :bids

  def admin?
    role == 'admin'
  end

  def seller?
    role == 'seller'
  end

  def buyer?
    role == 'buyer'
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.generate_otp_secret
    ROTP::Base32.random_base32
  end

  def self.generate_otp(otp_secret)
    totp = ROTP::TOTP.new(otp_secret)
    totp.now
  end
end
