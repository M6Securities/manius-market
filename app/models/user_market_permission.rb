class UserMarketPermission < ApplicationRecord

  SITE_ADMIN = 0
  ADMIN = 1

  PERMISSIONS_ARRAY = [
    SITE_ADMIN,
    ADMIN
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

  def permission?(p)
    p = p.to_i

    return true if formatted_permissions.include?(SITE_ADMIN)
    return true if (formatted_permissions.include?(ADMIN)) && (p != SITE_ADMIN)

    formatted_permissions.include? p
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
