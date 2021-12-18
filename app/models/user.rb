# frozen_string_literal: true

# user class
class User < ApplicationRecord
  SYSTEM = -1

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

  def permission?(permission = nil, market = nil)
    # if the user is a site admin it will always return true
    return true if site_admin

    # if the user has no permissions with the market it will always return false
    return false unless markets.include? market

    market_permissions = user_market_permissions.find_by(user_id: id).permissions

    # if the user is an owner of the market return true
    return true if market_permissions.include? UserMarketPermission::OWNER

    # if the user is an admin of the market return true
    return true if market_permissions.include? UserMarketPermission::ADMIN

    return market_permissions.include? permission.to_i

    false
  end

  def has_market?
    key = has_market_key
    cache = Rails.cache.read(key)

    if cache.nil?
      cache = !markets.size.zero?
      Rails.cache.write(key, cache, expires_in: 5.minutes)
    end

    cache
  end

  def reset_has_market
    key = has_market_key
    Rails.cache.write(key, markets.size.zero?, expires_in: 5.minutes)
  end

  private

  def has_market_key
    "user_#{id}_has_market"
  end

end
