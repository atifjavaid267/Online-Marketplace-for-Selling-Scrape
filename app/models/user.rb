class User < ApplicationRecord
  #  provisioning_uri user.generate_totp_secret
  #   user. # This assumes a user model with an email attribute
  # has_secure_password
  # include ActiveModel::OTP

  # has_one_time_password(encrypted: true)
  # def need_two_factor_authentication?(request)
  #   request.ip != '127.0.0.1'
  # end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :two_factor_authenticatable, :database_authenticatable, :registerable,
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
