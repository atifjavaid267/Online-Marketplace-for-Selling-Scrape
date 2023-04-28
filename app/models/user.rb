class User < ApplicationRecord
  # attr_reader :iv, :salt, :otp_secret

  # gem 'devise-two-factor'
  devise :two_factor_authenticatable,
         otp_secret_encryption_key: ENV['encryption_key_env']

  def self.generate_otp_secret
    ROTP::Base32.random_base32
  end

  def self.generate_otp(encrypted_otp_secret)
    totp = ROTP::TOTP.new(encrypted_otp_secret)
    totp.now
  end
  #  provisioning_uri user.generate_totp_secret
  #   user. # This assumes a user model with an email attribute
  # has_secure_password
  # include ActiveModel::OTP

  # has_one_time_password(encrypted: true)
  # def need_two_factor_authentication?(request)
  #   request.ip != '127.0.0.1'
  # end

  ################################
  ## gem 'active_model_otp' ##
  ################################

  # OTP_AUTH_EXPIRES_IN = 24.hours

  # # for gem 'active_model_otp'
  # has_one_time_password
  # has_one_time_password column_name: :my_otp_secret_column, length: 4
  # has_one_time_password after_column_name: :last_otp_at

  # def send_otp_mail
  #   AdminMailer.user_otp(email, otp_code).deliver_now
  # end

  # def otp_authenticated?
  #   return unless otp_auth_at?

  #   otp_auth_at + OTP_AUTH_EXPIRES_IN > Time.zone.now
  # end

  ################################

  ################################
  ## TWO FACTOR AUTHENTICATION ##
  ################################

  # devise :two_factor_authenticatable, otp_secret_encryption_key: ENV['OTP_SECRET_ENCRYPTION_KEY']

  # # FOR TWO FACTOR Authentication (FOR SENDING OTP)
  # def send_two_factor_authentication_code(code)
  #   # Send code via SMS, etc.
  # end

  # for two factor authentication
  # has_one_time_password(encrypted: true)

  # def need_two_factor_authentication?(request)
  #   request.ip != '127.0.0.1'
  # end

  ################################
  ################################

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :validatable, :two_factor_authenticatable

  has_many :products
  has_many :ads
  has_many :addresses
  has_many :bids

  ROLES = %w[admin seller buyer].freeze

  def admin?
    role == 'admin'
  end

  def seller?
    role == 'seller'
  end

  def buyer?
    role == 'buyer'
  end
end
