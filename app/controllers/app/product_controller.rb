# frozen_string_literal: true

module App

  # view and edit products for current market
  class ProductController < AppController
    before_action :require_market

    def new
      @product = Product.new
    end

    def create
      safe_params = params.require(:create).permit(:name, :sku, :price, :stock, :tax_code)

      @product = Product.new safe_params
      @product.market = @current_market

      if @product.invalid?
        return respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
        end
      end

      @product.save

      redirect_to app_product_path(@product.id)
    end

    def show
      @product = Product.find_by(id: params[:id])
    end

    def edit
      @product = Product.find_by(id: params[:id])
    end

    def update
      @product = Product.find_by(id: params[:id])

      safe_params = params.require(:update).permit(:name, :sku, :price, :stock, :tax_code)

      if @product.update safe_params
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

      return unless %w[id sku name price quantity].include? sort_name

      filtered_count = Product.all.size
      records = Product.order(sort_name => sort_dir).select(:id, :sku, :name, :price, :stock).limit(requested_length).offset(requested_start)

      ActiveRecord::Base.include_root_in_json = false

      payload = {
        draw: params[:draw],
        recordsTotal: Product.all.size,
        recordsFiltered: filtered_count,
        data: records
      }

      render json: payload, status: :ok
    end

  end
end
