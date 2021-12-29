require 'stripe'

class UpdateStripeProductPriceWorker
  include Sidekiq::Worker

  def perform(price_id)
    product_price = ProductPrice.find_by id: price_id
    Stripe.api_key = product_price.market.stripe_secret_key

    Stripe::Price.update(
      product_price.stripe_price_id,
      unit_amount: product_price.price.cents,
      currency: product_price.price.currency.iso_code.downcase
    )
  end
end
