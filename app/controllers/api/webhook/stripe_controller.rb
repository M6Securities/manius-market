# frozen_string_literal: true

module Api
  module Webhook
    # handles all stripe webhooks
    class StripeController < WebhookController
      def index
        # Verify webhook signature and extract the event
        # See https://stripe.com/docs/webhooks/signatures for more information.
        begin
          sig_header = request.env['HTTP_STRIPE_SIGNATURE']
          payload = request.body.read

          # only print this out if we're in development mode
          puts payload if Rails.env.development?

          Stripe.api_key = @current_market.stripe_secret_key
          event = Stripe::Webhook.construct_event(payload, sig_header, @current_market.stripe_webhook_secret)

          case event['type']
          when 'checkout.session.completed'
            checkout_session_completed event
          # payment intent canceled
          when 'payment_intent.canceled'
            update_payment_intent event
          # payment intent created
          when 'payment_intent.created'
            update_payment_intent event
          # payment intent payment failed
          when 'payment_intent.payment_failed'
            update_payment_intent event
          # payment intent processing
          when 'payment_intent.processing'
            update_payment_intent event
          # payment intent requires action
          when 'payment_intent.requires_action'
            update_payment_intent event
          # payment intent succeeded
          when 'payment_intent.succeeded'
            update_payment_intent event
          when 'customer.created'
            customer_created event
          end
        rescue JSON::ParserError => e
          # Invalid payload
          return status 400
        rescue Stripe::SignatureVerificationError => e
          # Invalid signature
          return status 400
        end

        # Print out the event so you can look at it
        # puts event.inspect

        render status: 200, json: { status: 'success' }, layout: false
      end

      private

      # TODO: - move these to workers, so they can be executed in parallel

      def checkout_session_completed(event)
        checkout_session_id = event['data']['object']['id']
        order = Order.find_by stripe_checkout_session_id: checkout_session_id

        # clear the cart since the order was placed
        order.customer.cart_items.destroy_all

        line_items = Stripe::Checkout::Session.list_line_items(checkout_session_id)['data']

        line_items.each do |line_item|
          product = Product.find_by stripe_product_id: line_item['price']['product']
          order_item = order.order_items.find_by(product_id: product.id)

          line_item_quantity = line_item['quantity']

          order_item.stripe_line_item_id = line_item['id']
          order_item.quantity = line_item_quantity if order_item.quantity != line_item_quantity

          order_item.save
        end
        order.action_logs.create(
          action: 'Order Placed',
          user_id: User::SYSTEM_USER_ID
        )
      end

      def update_payment_intent(event)
        payment_intent_id = event['data']['object']['id']
        payment_intent_status = event['data']['object']['status']
        order = Order.find_by stripe_payment_intent_id: payment_intent_id

        case payment_intent_status
        when 'requires_payment_method'
          order.assign_attributes payment_status: Order::PS_REQUIRES_PAYMENT_METHOD
        when 'requires_confirmation'
          order.assign_attributes payment_status: Order::PS_REQUIRES_CONFIRMATION
        when 'requires_action'
          order.assign_attributes payment_status: Order::PS_REQUIRES_ACTION
        when 'processing'
          order.assign_attributes payment_status: Order::PS_PROCESSING
        when 'requires_capture'
          order.assign_attributes payment_status: Order::PS_REQUIRES_CAPTURE
        when 'succeeded'
          order.assign_attributes payment_status: Order::PS_SUCCEEDED
        when 'canceled'
          order.assign_attributes payment_status: Order::PS_CANCELED
        else
          order.assign_attributes payment_status: Order::PS_NONE
        end

        total_price = Money.from_cents(event['data']['object']['amount'], event['data']['object']['currency'])

        order.total_price = total_price

        order.save

        order.action_logs.create(
          action: "Payment Intent Updated to #{payment_intent_status}",
          user_id: User::SYSTEM_USER_ID
        )
      end

      def customer_created(event)
        # puts 'Customer Created event'
        customer_id = event['data']['object']['id']
        customer = Customer.find_by email: event['data']['object']['email']
        customer.update real: true, stripe_customer_id: customer_id
      end

      # end of class
    end
  end
end
