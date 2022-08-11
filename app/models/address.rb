# frozen_string_literal: true

# Addresses
# They're kinda free for all.
# They can be attached to any model.
# They will not be entirely validated.
# Instead validation should be done at the controller level.
# This way they are flexible for many different situations.
class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :street_1, presence: true
  validates :city, presence: true
  validates :country, presence: true, length: { is: 2 }
  validates :postal_area, presence: true
  validates :contact_name, presence: true

  enum :address_type, {
    residential: 0,
    business: 1,
    po_box: 2,
    apartment: 3,
    building: 4,
    floor: 5,
    office: 6,
    suite: 7,

    # keep other at the bottom
    other: 99
  }
end
