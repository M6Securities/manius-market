require 'stripe'

class UpdateStripeProductPriceWorker
  include Sidekiq::Worker

  def perform(price_id)
    product_price = ProductPrice.find_by id: price_id
    Stripe.api_key = product_price.market.stripe_secret_key

    # So we cannot update price amount via the API. So what we have to do is disable the current price on stripe, and create a new one with the new amount, but only if they're different.
    old_stripe_price = Stripe::Price.retrieve product_price.stripe_price_id

    same_price = true

    same_price = false if old_stripe_price.unit_amount != product_price.price.cents
    same_price = false if old_stripe_price.currency != product_price.price.currency.iso_code.downcase
    same_price = false if old_stripe_price.product != product_price.product.stripe_product_id # probably not needed but I guess why not

    unless same_price
      # disable the old price
      Stripe::Price.update(
        product_price.stripe_price_id,
        active: false
      )
      # create a new price. Why repeat code?
      CreateStripeProductPriceWorker.perform_async(product_price.id)
    end



  end
end
