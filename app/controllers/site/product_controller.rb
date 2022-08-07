# frozen_string_literal: true

module Site
  # public product controller
  class ProductController < SiteController
    def index
      @products = @current_market.products.all

      @pagy, @products = pagy(@products)
    end

    def show
      @product = Product.find(params[:id])

      redirect_to :index unless @product.market.id == @current_market.id
    end
  end
end
