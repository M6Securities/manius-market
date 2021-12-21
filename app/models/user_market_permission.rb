class UserMarketPermission < ApplicationRecord
  OWNER = 0
  ADMIN = 1
  MEMBER = 2

  PERMISSIONS_ARRAY = [
    OWNER,
    ADMIN,
    MEMBER
  ].freeze

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
end
