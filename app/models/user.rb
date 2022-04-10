# frozen_string_literal: true

# user class
class User < ApplicationRecord
  SYSTEM_USER_ID = -1

  # Devise
  # ---------------------------------------------------------------------------

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
         # :password_expirable,
         :password_archivable,
         # :secure_validatable,
         :expirable,
         :session_limitable

  # before_create :check_if_first_user

  # Associations
  # ---------------------------------------------------------------------------
  has_many :user_market_permissions
  has_many :markets, through: :user_market_permissions
  has_many :customers
  has_many :cart_items, through: :customers
  has_many :orders, through: :customers

  # Validations
  # ---------------------------------------------------------------------------
  validates_with EmailAddress::ActiveRecordValidator, if: !Rails.env.test?

  validates :display_name, presence: true
  validates :email, presence: true, uniqueness: true

  # Methods
  # ---------------------------------------------------------------------------

  def gravatar
    hash = email.nil? ? Digest::MD5.hexdigest(username) : Digest::MD5.hexdigest(email)

    "https://www.gravatar.com/avatar/#{hash}?d=identicon"
  end

  # given a permission constant, and a market OR permission object, check if the user has permission
  def permission?(permission = nil, market_or_permissions = nil)
    # if the user is a site admin it will always return true
    return true if site_admin

    return false if permission.nil? || market_or_permissions.nil?

    if market_or_permissions.is_a? Market
      market = market_or_permissions
      market_permissions = market.user_market_permissions.find_by(user_id: id)
    else
      market_permissions = market_or_permissions
      market = market_permissions.market
    end

    key = "user_#{id}_market_#{market.id}_permission_#{permission}"
    expire = 5.minutes.freeze

    cached = Rails.cache.read key
    return cached unless cached.nil?

    # if the user has no permissions with the market it will always return false
    return false unless markets.include? market

    # market_permissions = user_market_permissions.find_by(market_id: market.id).permissions

    # if the user is an owner of the market return true
    if market_permissions.include? UserMarketPermission::OWNER
      Rails.cache.write key, true, expires_in: expire
      return true
    end

    # if they're really an owner it would've already returned true
    return false if permission == UserMarketPermission::OWNER

    # if the user is an admin of the market return true
    if market_permissions.include? UserMarketPermission::ADMIN
      Rails.cache.write key, true, expires_in: expire
      return true
    end

    if market_permissions.include? permission.to_i
      Rails.cache.write key, true, expires_in: expire
      return true
    end

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

  def check_if_first_user
    site_admin = true if User.all.size.zero?
  end
end
