# frozen_string_literal: true

module App
  module MarketSpace
    # view and edit products for current market
    class ProductController < MarketSpaceController
      before_action :require_market
      before_action :find_product, except: %i[index create datatable]

      def create
        safe_params = params.require(:create).permit(:name, :sku, :stock, :tax_code, :description)

        @product = Product.new safe_params
        @product.market = @current_market
        @product.enabled = false # set to false until user adds pricing

        if @product.invalid?
          p @product.errors.messages
          return render :new, status: :unprocessable_entity
        end

        @product.save

        redirect_to app_market_space_product_path(@product.id)
      end

      def update
        safe_params = params.require(:update).permit(:name, :sku, :stock, :tax_code, :description, :enabled, :shippable, product_price: %i[price currency])

        # our toggable keys
        %i[enabled shippable].each do |key|
          safe_params[key] = safe_params[key] == 'on'
        end

        prices = []
        safe_params[:product_price].each do |product_price|
          prices << Money.new(product_price[:price], product_price[:currency])
        end

        prices.each do |price|
          product_price = @product.product_prices.find_by price_currency: price.currency.iso_code
          product_price = @product.product_prices.new if product_price.nil?

          # puts "\n\n\n Current Product price: #{product_price.price} \n New Product Price: #{price} \n\n\n"

          product_price.price = price
          product_price.save
        end

        update_keys = %i[name sku stock tax_code description enabled shippable].freeze

        if log_model_updates(update_keys, @product, safe_params, @user_market_permissions)
          render :show # don't redirect, just show the updated product
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def datatable
        requested_length = params[:length].to_i
        requested_start  = params[:start].to_i

        sort_col = params['order']['0']['column'] # eg 0 for column 0
        sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
        sort_name = params['columns'][sort_col]['name'] # the column name set in the data table initialization. MUST equal the DB column name
        search_value = params['search']['value']

        return unless %w[id sku name stock].include? sort_name

        filtered_count = Product.where(market_id: @current_market.id).size
        records = Product.where(market_id: @current_market.id).order(sort_name => sort_dir).select(:id, :sku, :name, :stock).limit(requested_length).offset(requested_start)

        ActiveRecord::Base.include_root_in_json = false

        payload = {
          draw: params[:draw],
          recordsTotal: Product.where(market_id: @current_market.id).size,
          recordsFiltered: filtered_count,
          data: records
        }

        render json: payload, status: :ok
      end

      def orders_datatable
        requested_length = params[:length].to_i
        requested_start = params[:start].to_i

        sort_col = params['order']['0']['column'] # eg 0 for column 0
        sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
        sort_name = params['columns'][sort_col]['name'] # the column name set in the data table initialization. MUST equal the DB column name
        search_value = params['search']['value']

        return unless %w[orders.created_at orders.payment_status orders.status].include? sort_name

        column_select = %w[orders.id orders.created_at orders.payment_status orders.status COUNT(order_items.order_id)].freeze
        group_select = %w[orders.id order_items.order_id].freeze

        filtered_count = @product.orders.size
        records = @product.orders
                          .left_joins(:order_items)
                          .order(sort_name => sort_dir)
                          .select(column_select)
                          .group(group_select)
                          .limit(requested_length)
                          .offset(requested_start)

        ActiveRecord::Base.include_root_in_json = false

        payload = {
          draw: params[:draw],
          recordsTotal: @product.orders.size,
          recordsFiltered: filtered_count,
          data: records
        }

        render json: payload, status: :ok
      end

      private

      def find_product
        @product = if !params[:id].blank?
                     @current_market.products.find_by(id: params[:id])
                   elsif !params[:product_id].blank?
                     @current_market.products.find_by(id: params[:product_id])
                   else
                     @current_market.products.new
                   end
      end
    end
  end
end
