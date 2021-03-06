require 'stripe'

class CreateStripeProductWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(product_id)
    product = Product.find(product_id)

    Stripe.api_key = product.market.stripe_secret_key

    stripe_product = Stripe::Product.create(
      id: product.stripe_product_id,
      name: product.name,
      active: product.enabled,
      description: product.description,
      shippable: product.shippable,
      tax_code: product.tax_code
    )

    product.update stripe_product_id: stripe_product.id
  end
end
