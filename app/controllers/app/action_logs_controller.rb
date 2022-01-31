# frozen_string_literal: true

module App
  class ActionLogsController < ApplicationController
    def datatable
      model = params[:model]
      model_id = params[:model_id]

      action_logs = ActionLog.where(loggable_type: model, loggable_id: model_id)

      puts action_logs

      requested_length = params[:length].to_i
      requested_start  = params[:start].to_i

      sort_col = params['order']['0']['column'] # eg 0 for column 0
      sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
      sort_name = params['columns'][sort_col]['name'] # the column name set in the data table initialization. MUST equal the DB column name
      search_value = params['search']['value']

      return unless %w[created_at event].include? sort_name

      column_select = %w[created_at action users.id].freeze
      # group_select = %w[orders.id order_items.order_id].freeze

      filtered_count = action_logs.size
      records = action_logs.joins(user_market_permission: :user)
                           .select(column_select)
                           .order(sort_name => sort_dir)
                           .limit(requested_length)
                           .offset(requested_start)

      ActiveRecord::Base.include_root_in_json = false

      payload = {
        draw: params[:draw],
        recordsTotal: action_logs.size,
        recordsFiltered: filtered_count,
        data: records
      }

      render json: payload, status: :ok
    end
  end
end
