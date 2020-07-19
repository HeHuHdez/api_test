# frozen_string_literal: true

module Api
  # Product controller
  class ProductsController < ApplicationController
    before_action :set_product, only: %i[show update destroy]

    # GET /api/products
    def index
      @products = Product.all
      json_response(@products)
    end

    # GET /api/products/1
    def show
      json_response(@product)
    end

    # POST /api/products
    def create
      @product = Product.new(product_params)
      if @product.save
        json_response(@product, :created, location: @product)
      else
        json_response(@product.errors, :unprocessable_entity)
      end
    end

    # PATCH/PUT /api/products/1
    def update
      if @product.update(product_params)
        json_response(@product)
      else
        json_response(@product.errors, :unprocessable_entity)
      end
    end

    # DELETE /api/products/1
    def destroy
      @product.destroy
    end

    def populars
      result = Product.total_orders.sort_by { |_k, v| -v }
      result = result.first(params[:limit].to_i) if params[:limit]
      json_response(result.to_h)
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description)
    end
  end
end
