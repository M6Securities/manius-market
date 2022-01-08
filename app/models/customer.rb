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

  # Validations
  # ------------------------------------------------------------
  validates_presence_of :market
  validates :real, inclusion: { in: [true, false] }

  # Methods
  # ------------------------------------------------------------

  # returns a money object of the cart total
  def cart_total
    total = 0
    cart_items.each do |item|
      total += item.product.product_price_from_currency(market.default_currency).price.cents * item.quantity
    end

    Money.new(total, 'USD')
  end
end
