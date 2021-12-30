require 'stripe'

class CreateStripeProductPriceWorker
  include Sidekiq::Worker

  def perform(price_id)
    product_price = ProductPrice.find_by id: price_id
    Stripe.api_key = product_price.market.stripe_secret_key

    stripe_price = Stripe::Price.create(
      product: product_price.product.stripe_product_id,
      unit_amount: product_price.price.cents,
      currency: product_price.price.currency.iso_code.downcase
    )

    product_price.update stripe_price_id: stripe_price.id
  end
end
