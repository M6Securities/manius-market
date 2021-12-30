require 'stripe'

class UpdateStripeProductWorker
  include Sidekiq::Worker

  def perform(product_id)
    product = Product.find(product_id)

    Stripe::Product.update(
      product.stripe_product_id,
      name: product.name,
      active: product.enabled,
      description: product.description,
      shippable: product.shippable,
      tax_code: product.tax_code
    )
  end
end
