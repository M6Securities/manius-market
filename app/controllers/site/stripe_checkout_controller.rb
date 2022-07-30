# frozen_string_literal: true

module Site
  # Handles Stripe Checkout for Orders
  class StripeCheckoutController < SiteController
    def create
      # at this point, we are in the checkout process
      # So we need to remove all items from the cart and create an order with it

      order = @current_customer.orders.create payment_status: :none

      safe_params = params.require(:create).permit(:shipping_name, :email, :address_line_1, :address_line_2, :city, :state, :zip, :country)

      customer_email = safe_params[:email]

      puts safe_params

      return render json: { error: 'Email is required' }, status: :unprocessable_entity unless customer_email.present?

      possible_existing_customer = @current_customer.market.customers.find_by(email: customer_email)

      if possible_existing_customer.nil?
        puts 'Creating new customer'
        # no customer exists with this email, so we use the current one
        order.customer.email = customer_email

        puts order.customer.inspect
        puts "Valid? #{order.customer.valid?}"
        puts 'Customer Erorrs'
        puts order.customer.errors.inspect
        puts order.customer.errors.full_messages.inspect
        puts order.customer.save

        puts 'Order Errors'
        puts order.errors.inspect
        puts order.errors.full_messages.inspect

        return render json: { error: 'Email is invalid' }, status: :unprocessable_entity unless order.customer.save
      elsif possible_existing_customer.id != @current_customer.id
        # if a customer already exists and it's NOT the same customer object, then we need to transfer over the cart to that one.
        # This sitatution happens when a customer uses guest checkout twice, or isn't logged in. This way their orders are still tracked to their user
        @current_customer.cart_items.each do |cart_item|
          cart_item.update customer_id: possible_existing_customer.id
        end
        # then we destroy the old customer
        possible_existing_customer.session_id = @current_customer.session_id
        @current_customer.destroy
        @current_customer = possible_existing_customer
        @current_customer.save
      end

      order.save

      @current_customer.cart_items.each do |cart_item|
        order.order_items.create(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity
        )
      end

      order.assign_attributes safe_params.except(:email)

      if order.invalid?
        puts "Invalid Order: #{order.errors.messages}"
        return render json: { error: 'Invalid Order' }, status: :unprocessable_entity
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

      puts "Line Items: #{line_items}"

      Stripe.api_key = @current_customer.market.stripe_secret_key

      checkout_session_object = {
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
        cancel_url: stripe_checkout_cancel_url(order_id: order.id)
      }

      if @current_customer.stripe_customer_id.present?
        checkout_session_object[:customer] = @current_customer.stripe_customer_id
      else
        checkout_session_object[:customer_email] = @current_customer.email
      end

      session = Stripe::Checkout::Session.create(checkout_session_object)

      puts "Payment Intent: #{session.payment_intent} \n\n"

      render json: { id: session.id }, status: :ok if order.update(stripe_checkout_session_id: session.id, stripe_payment_intent_id: session.payment_intent)
    end

    def cancel
      order = Order.find_by(id: params[:order_id])

      return redirect_to cart_path if order.nil?

      # if the customer cancels, destroy the order, but only if they're the current customer on the order
      # That way, you can't just take an order ID and cancel it via a get request
      order.destroy if (order.customer_id == @current_customer.id) && order.status.zero? && order.payment_status.zero?

      redirect_to cart_path
    end
  end
end
