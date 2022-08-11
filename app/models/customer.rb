# frozen_string_literal: true

# Customer model
#
# Contains information about a customer WITHIN the market scope
# If the customer is tied to a user, then the relevant information is pulled from there.
# But if not, aka guest checkout, then the information stored is pulled from what the clint enters.
#
# The real attribute is tricky. It's false until checkout is attempted.
# I needed a way to store cart items in the database, so that carts will sync between sessions if the user is logged in.
# And it needed to be market specific.
# The real attribute is basically a way to determine if the possible customer is a guest, and if they never check out, we can delete the cart after a month or something.
class Customer < ApplicationRecord
  # Associations
  # ------------------------------------------------------------
  belongs_to :user, optional: true
  belongs_to :market, optional: false

  has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy

  # Validations
  # ------------------------------------------------------------
  validates_presence_of :market
  validates :real, inclusion: { in: [true, false] }
  validates :email,
            presence: true,
            uniqueness: {
              scope: :market_id
            },
            allow_blank: true,
            email: true,
            unless: proc { |_c| Rails.env.test? }

  # Methods
  # ------------------------------------------------------------

  # returns a money object of the cart total
  def cart_total
    # yes there's a clever way to do with .sum() in the database, but this is way more readable
    #
    # TODO cache this for faster page loads
    total = Money.from_cents(0, market.default_currency)
    cart_items.each do |item|
      total += item.price_total(market.default_currency)
    end
    total
  end

  # returns the number of cart items in the cart
  def num_cart_items
    cart_items.sum(:quantity)
  end

  def display_name
    user&.display_name
  end
end
