# frozen_string_literal: true

module Site
  # handles everything cart related on the front end
  class CartController < SiteController
    layout 'application'

    def navbar; end

    def update_item
      safe_params = params.require(:add).permit(:product_id, :quantity)

      quantity = safe_params[:quantity].to_i
      product = Product.find_by id: safe_params[:product_id]

      return render status: :bad_request, json: { message: 'Product not found' } if product.nil?

      quantity = 1 if quantity < 1

      cart_item = @current_customer.cart_items.find_by(product_id: product.id)

      if cart_item.nil?
        @current_customer.cart_items.create(product_id: product.id, quantity: quantity)
      else
        cart_item.update(quantity: quantity)
      end

      render status: :ok, json: { message: 'Product added to cart' }
    end
  end
end
