class User < ApplicationRecord
  has_many :products
  has_many :ads
  has_many :addresses

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
