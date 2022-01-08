# frozen_string_literal: true

module Site
  # Handles Stripe Checkout for Orders
  class StripeCheckoutController < SiteController
    def create
      # at this point, we are in the checkout process
      # So we need to remove all items from the cart and create an order with it

      order = @current_customer.orders.create payment_status: Order::PS_NONE

      @current_customer.cart_items.each do |cart_item|
        order.order_items.create(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity
        )
        # cart_item.destroy
      end

      line_items = []
      order.order_items.each do |order_item|
        line_items << {
          price: order_item.product.product_price_from_currency(@current_market.default_currency).stripe_price_id,
          quantity: order_item.quantity,
          adjustable_quantity: {
            enabled: true,
            minimum: 1,
            maximum: 10
          }
        }
      end

      Stripe.api_key = @current_customer.market.stripe_secret_key

      session = Stripe::Checkout::Session.create({
                                                   # rubocop:disable Style/HashSyntax
                                                   # Bruh idk what's going on but rubocop keeps removing the line_items variable
                                                   line_items: line_items,
                                                   # rubocop:enable Style/HashSyntax
                                                   mode: 'payment',
                                                   automatic_tax: {
                                                     enabled: true
                                                   },
                                                   billing_address_collection: 'required',
                                                   success_url: stripe_checkout_success_url,
                                                   cancel_url: cart_url # stripe_checkout_cancel_url
                                                 })
      render json: { id: session.id }, status: :ok if order.update(stripe_checkout_session_id: session.id, stripe_payment_intent_id: session.payment_intent)
    end
  end
end
