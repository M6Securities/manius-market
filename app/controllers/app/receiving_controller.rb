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

    def edit
      render 'error/unauthorized', status: :unauthorized, layout: 'error' unless (current_user.id != @receiving.user_id) || current_user.permission?(UserMarketPermission::ADMIN, @current_market)
    end

    def update
      return render 'error/unauthorized', status: :unauthorized, layout: 'error' unless (current_user.id != @receiving.user_id) || current_user.permission?(UserMarketPermission::ADMIN, @current_market)

      new_item = params[:new][:sku]

      items = if params[:update].nil?
                []
              else
                params[:update][:items]
              end

      items.each do |item|
        receive_item = ReceiveItem.find_by id: item[:id]

        item[:quantity] = item[:quantity].to_i

        if receive_item.nil?
          flash[:error] = 'Product not found'
          return render :edit, status: :unprocessable_entity
        end

        next if receive_item.quantity == item[:quantity]

        difference = item[:quantity] - receive_item.quantity

        receive_item.update quantity: item[:quantity]

        receive_item.product.stock += difference
        receive_item.product.save

        flash[:success] = 'Receiving updated'
      end

      unless new_item.blank?
        product = Product.find_by(sku: new_item)

        if product.nil?
          flash[:error] = 'Product not found'
          return render :edit, status: :unprocessable_entity
        end

        receive_item = ReceiveItem.find_by receive_id: @receiving.id, product_id: product.id

        if receive_item.nil?
          receive_item = @receiving.receive_items.create product_id: product.id, quantity: 1
        else
          receive_item.quantity += 1
        end

        puts product
        puts receive_item
        puts receive_item.quantity
        puts receive_item.product_id
        puts receive_item.product
        puts 'Printed stuff'

        receive_item.product.stock += 1
        receive_item.product.save

        receive_item.save

        flash[:success] = 'Receiving updated'
      end

      render :edit
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

    def receiving_item_line
      @item = ReceiveItem.find_by id: params[:receive_item], receive_id: params[:receiving_id]

      return render 'error/bad_request', status: :bad_request, layout: 'error' if @item.nil?

      @item
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
