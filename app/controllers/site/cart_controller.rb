# frozen_string_literal: true

module Site
  # handles everything cart related on the front end
  class CartController < SiteController
    before_action :fetch_numbers

    def navbar
      @show_navbar_cart = params[:show_cart] == 'true'

      # https://api.rubyonrails.org/classes/ActionView/Layouts.html -> Types of Layouts
      # Basically this renders itself but without a layout...
      render action: :navbar, layout: false
    end

    def update_item
      safe_params = params.require(:add).permit(:product_id, :quantity)

      quantity = safe_params[:quantity].to_i
      product = Product.find_by id: safe_params[:product_id]

      return render status: :bad_request, json: { message: 'Product not found' } if product.nil?

      quantity = 1 if quantity < 1

      cart_item = @current_customer.cart_items.find_by(product_id: product.id)

      if cart_item.nil?
        @current_customer.cart_items.create(product_id: product.id, quantity:)
      else
        quantity += cart_item.quantity
        cart_item.update(quantity:)
      end

      render status: :ok, json: { message: 'Product added to cart' }
    end

    def update_cart
      # so params[:update] may or may not exist. So if it doesn't exist, we'll just assume the cart is empty and wipe it

      if params[:update].nil?
        @current_customer.cart_items.destroy_all

        @cart_items_count = 0
        @cart_total = @current_customer.cart_total # can't manually set to 0.00

        # return render :navbar, status: :ok, layout: false
        return nil
      end

      param_cart_item_ids = []
      params[:update][:cart_items].each do |param_cart_item|
        param_cart_item_ids << param_cart_item[:id]

        cart_item = CartItem.find_by id: param_cart_item[:id]

        return render status: :bad_request, json: { message: 'Cart item not found' }, text: 'Cart item not found' if cart_item.nil?

        if param_cart_item[:quantity].to_i.zero?
          cart_item.destroy
        else
          cart_item.update(quantity: param_cart_item[:quantity])
        end
      end

      @current_customer.cart_items.each do |cart_item|
        cart_item.destroy unless param_cart_item_ids.include?(cart_item.id)
      end

      @show_navbar_cart = true

      # render turbo_stream: turbo_stream.replace('cart_items', partial: 'site/cart/cart_item', locals: { customer: @current_customer })
    end

    private

    def fetch_numbers
      @cart_items_count = @current_customer.num_cart_items
      @cart_total = @current_customer.cart_total
    end
  end
end
