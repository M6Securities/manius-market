# frozen_string_literal: true

module App
  module UserSpace
    class OrderController < UserSpaceController
      def datatable
        requested_length = params[:length].to_i
        requested_start  = params[:start].to_i

        sort_col = params['order']['0']['column'] # eg 0 for column 0
        sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
        sort_name = params['columns'][sort_col]['name'].to_s # the column name set in the data table initialization. MUST equal the DB column name
        search_value = params['search']['value']

        return unless %w[orders.created_at orders.status].include? sort_name

        column_select = %w[orders.id orders.created_at orders.status COUNT(order_items.order_id)].freeze
        group_select = %w[orders.id order_items.order_id].freeze

        filtered_count = current_user.orders.size
        records = current_user.orders
                              .left_joins(:order_items)
                              .order(sort_name => sort_dir)
                              .select(column_select)
                              .group(group_select)
                              .limit(requested_length)
                              .offset(requested_start)

        ActiveRecord::Base.include_root_in_json = false

        payload = {
          draw: params[:draw],
          recordsTotal: current_user.orders.size,
          recordsFiltered: filtered_count,
          data: records
        }

        render json: payload, status: :ok
      end
    end
  end
end
