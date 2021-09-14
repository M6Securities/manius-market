class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         # :confirmable,
         :lockable,
         :timeoutable,
         :trackable,
         # :omniauthable,
         :password_expirable,
         :password_archivable,
         # :secure_validatable,
         :expirable,
         :session_limitable

  validates_with EmailAddress::ActiveRecordValidator

  has_many :user_market_permissions
  has_many :markets, through: :user_market_permissions

  validates :display_name, presence: true
  validates :email, presence: true, uniqueness: true

  def gravatar
    hash = email.nil? ? Digest::MD5.hexdigest(username) : Digest::MD5.hexdigest(email)

    "https://www.gravatar.com/avatar/#{hash}?d=identicon"
  end
end
