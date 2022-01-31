class UserMarketPermission < ApplicationRecord
  OWNER = 0
  ADMIN = 1
  MEMBER = 2
  VIEW_PRODUCTS = 3
  EDIT_PRODUCTS = 4
  RECEIVE_PRODUCTS = 5
  VIEW_ORDERS = 6
  EDIT_ORDERS = 7
  VIEW_CUSTOMERS = 8
  EDIT_CUSTOMERS = 9

  PERMISSIONS_ARRAY = [
    OWNER,
    ADMIN,
    MEMBER,
    VIEW_PRODUCTS,
    EDIT_PRODUCTS,
    RECEIVE_PRODUCTS,
    VIEW_ORDERS,
    EDIT_ORDERS,
    VIEW_CUSTOMERS,
    EDIT_CUSTOMERS
  ].freeze

  after_update :update_cache

  # Associations
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :user
  belongs_to :market

  has_many :action_logs, as: :loggable

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
