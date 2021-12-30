# frozen_string_literal: true

module Site
  # public product controller
  class ProductController < SiteController
    def index
      @products = Product.all
    end

    def show
      @product = Product.find(params[:id])
    end
  end
end
