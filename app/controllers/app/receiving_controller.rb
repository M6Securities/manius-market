# frozen_string_literal: true

module App
  # handles receiving of new product stock
  class ReceivingController < AppController
    before_action :check_permissions
    before_action :find_receive, except: %i[index datatable]


    def new
      @receiving = Receive.new user_id: current_user.id, market_id: @current_market.id
      @receiving.save
      redirect_to edit_app_receiving_path(@receiving)
    end

    def datatable
      requested_length = params[:length].to_i
      requested_start  = params[:start].to_i

      sort_col = params['order']['0']['column'] # eg 0 for column 0
      sort_dir = params['order']['0']['dir'] # 'desc' or 'asc'
      sort_name = params['columns'][sort_col]['name'] # the column name set in the data table initialization. MUST equal the DB column name
      search_value = params['search']['value']

      return unless %w[id created_at user_id].include? sort_name

      filtered_count = Receive.where(market_id: @current_market.id).size
      records = Receive.where(market_id: @current_market.id).order(sort_name => sort_dir).select(:id, :created_at, :user_id).limit(requested_length).offset(requested_start)

      ActiveRecord::Base.include_root_in_json = false

      payload = {
        draw: params[:draw],
        recordsTotal: Product.where(market_id: @current_market.id).size,
        recordsFiltered: filtered_count,
        data: records
      }

      render json: payload, status: :ok
    end

    private

    def check_permissions
      render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::RECEIVE_PRODUCTS, @current_market)
    end

    def find_receive
      @receiving = if params[:id].blank?
                     Receive.new
                   else
                     Receive.find_by(id: params[:id])
                   end
    end

  end
end
