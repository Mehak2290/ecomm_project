class ProductsController < ApplicationController
    def index
      if params[:category_id]
        @category = Category.find(params[:category_id])
        @products = @category.products.with_attached_image
      else
        @products = Product.with_attached_image.all
      end
    end
  end
  