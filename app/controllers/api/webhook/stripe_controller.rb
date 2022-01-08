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

          puts payload

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

      def checkout_session_completed(event)
        puts 'Here!!!!'

        checkout_session_id = event['data']['object']['id']
        order = Order.find_by stripe_checkout_session_id: checkout_session_id

        order.customer.update real: true, stripe_customer_id: event['data']['object']['customer']

        puts order
      end

      def update_payment_intent(event)
        payment_intent_id = event['data']['object']['id']
        order = Order.find_by stripe_payment_intent_id: payment_intent_id

        case event['data']['object']['status']
        when 'requires_payment_method'
          order.update payment_status: Order::PS_REQUIRES_PAYMENT_METHOD
        when 'requires_confirmation'
          order.update payment_status: Order::PS_REQUIRES_CONFIRMATION
        when 'requires_action'
          order.update payment_status: Order::PS_REQUIRES_ACTION
        when 'processing'
          order.update payment_status: Order::PS_PROCESSING
        when 'requires_capture'
          order.update payment_status: Order::PS_REQUIRES_CAPTURE
        when 'succeeded'
          order.update payment_status: Order::PS_SUCCEEDED
        when 'canceled'
          order.update payment_status: Order::PS_CANCELED
        else
          order.update payment_status: Order::PS_NONE
        end
      end
    end
  end
end
