# frozen_string_literal: true

module App
  module MarketSpace
    # market customers
    class CustomerController < MarketSpaceController
      before_action :find_customer, except: %i[index create datatable]

      def index
        render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::VIEW_CUSTOMERS, @current_market)
      end

      def show
        render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::VIEW_CUSTOMERS, @current_market)
      end

      def datatable
        return render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::VIEW_CUSTOMERS, @current_market)

        requested_length = params[:length].to_i
        requested_start  = params[:start].to_i

        sort_col = params['order']['0']['column'] # eg 0 for column 0
        sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
        sort_name = params['columns'][sort_col]['name'] # the column name set in the data table initialization. MUST equal the DB column name
        search_value = params['search']['value']

        return unless %w[id email created_at].include? sort_name

        filtered_count = @current_market.customers.where(real: true).size
        records = @current_market.customers
                                 .where(real: true)
                                 .order(sort_name => sort_dir)
                                 .select(:id, :email, :created_at)
                                 .limit(requested_length)
                                 .offset(requested_start)

        ActiveRecord::Base.include_root_in_json = false

        payload = {
          draw: params[:draw],
          recordsTotal: @current_market.customers.size,
          recordsFiltered: filtered_count,
          data: records
        }

        render json: payload, status: :ok
      end

      def orders_datatable
        return render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::VIEW_CUSTOMERS, @current_market)

        requested_length = params[:length].to_i
        requested_start  = params[:start].to_i

        sort_col = params['order']['0']['column'] # eg 0 for column 0
        sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
        sort_name = params['columns'][sort_col]['name'] # the column name set in the data table initialization. MUST equal the DB column name
        search_value = params['search']['value']

        return unless %w[orders.created_at orders.payment_status orders.status].include? sort_name

        column_select = %w[orders.id orders.created_at orders.payment_status orders.status COUNT(order_items.order_id)].freeze
        group_select = %w[orders.id order_items.order_id].freeze

        filtered_count = @customer.orders.size
        records = @customer.orders
                           .left_joins(:order_items)
                           .order(sort_name => sort_dir)
                           .select(column_select)
                           .group(group_select)
                           .limit(requested_length)
                           .offset(requested_start)

        ActiveRecord::Base.include_root_in_json = false

        payload = {
          draw: params[:draw],
          recordsTotal: @customer.orders.size,
          recordsFiltered: filtered_count,
          data: records
        }

        render json: payload, status: :ok
      end

      private

      def find_customer
        @customer = if !params[:id].nil?
                      @current_market.customers.find_by(id: params[:id])
                    else
                      @current_market.customers.find_by(id: params[:customer_id])
                    end
      end
    end
  end
end
