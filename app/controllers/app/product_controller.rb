# frozen_string_literal: true

module App

  # view and edit products for current market
  class ProductController < AppController
    before_action :require_market

    def new
      @product = Product.new
    end

    def create
      safe_params = params.require(:create).permit(:name, :sku, :price, :quantity, :tax_code)

      @product = Product.new safe_params
      @product.market = @current_market

      if @product.invalid?
        return respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
        end
      end

      if @product.save
        return redirect_to app_product_index_path
      end

    end

    def datatable

    end

  end
end
