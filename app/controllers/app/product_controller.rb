# frozen_string_literal: true

module App

  # view and edit products for current market
  class ProductController < AppController
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

      redirect_to app_product_path(@product.id)
    end

    def update
      safe_params = params.require(:update).permit(:name, :sku, :stock, :tax_code, :description, product_price: [:price, :currency])

      prices = []
      safe_params[:product_price].each do |product_price|
        prices << Money.new(product_price[:price], product_price[:currency])
      end

      prices.each do |price|
        product_price = @product.product_prices.find_by price_currency: price.currency.iso_code
        product_price = @product.product_prices.new if product_price.nil?

        product_price.price = price
        product_price.save
      end

      if @product.update safe_params.except(:product_price)
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

    private

    def find_product
      @product = if params[:id].blank?
                   Product.new
                 else
                   Product.find_by(id: params[:id])
                 end
    end

  end
end
