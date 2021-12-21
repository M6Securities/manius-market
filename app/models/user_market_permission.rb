class UserMarketPermission < ApplicationRecord
  OWNER = 0
  ADMIN = 1
  MEMBER = 2
  VIEW_PRODUCTS = 3
  EDIT_PRODUCTS = 4

  PERMISSIONS_ARRAY = [
    OWNER,
    ADMIN,
    MEMBER,
    VIEW_PRODUCTS,
    EDIT_PRODUCTS
  ].freeze

  after_update :update_cache

  belongs_to :user
  belongs_to :market

  validates :formatted_permissions, presence: true
  validate :valid_permissions

  # permissions are stored like this:
  # 1;0;3
  def permissions
    permissions = []
    formatted_permissions.split(';').each do |p|
      permissions.append p.to_i
    end

    permissions
  end

  def self.format_permissions(permissions)
    permissions.join ';'
  end

  private

  def valid_permissions
    permissions.each do |p|
      next if PERMISSIONS_ARRAY.include? p

      errors.add(:formatted_permissions, 'invalid permission')
    end
  end

  def update_cache
    permissions.each do |permission|
      key = "user_#{user_id}_market_#{market_id}_permission_#{permission}"
      expire = 5.minutes.freeze

      Rails.cache.write(key, true, expires_in: expire)
    end
  end
end
