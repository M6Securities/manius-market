# frozen_string_literal: true

module Site
  # public product controller
  class ProductController < SiteController
    def index
      @products = Product.all
    end

    def show
      @product = Product.find(params[:id])

      redirect_to :index unless @product.market.id == @current_market.id
    end
  end
end
