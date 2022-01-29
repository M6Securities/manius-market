# frozen_string_literal: true

module App
  # market customers
  class CustomerController < AppController
    before_action :require_market
    before_action :find_customer, except: %i[index create datatable]

    def index
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

      filtered_count = @current_market.customers.size
      records = @current_market.customers
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

    private

    def find_customer
      @customer = @current_market.customers.find_by(id: params[:id])
      @customer ||= @current_market.customers.find_by(id: params[:product_id])
    end
  end
end
