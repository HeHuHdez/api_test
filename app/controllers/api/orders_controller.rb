# frozen_string_literal: true

module Api
  # Orders controller
  class OrdersController < ApplicationController
    before_action :set_order, only: %i[show update destroy products]

    # GET /api/orders
    def index
      @orders = Order.from_to(params[:starts], params[:ends])

      json_response(@orders)
    end

    # GET /api/orders/1
    def show
      json_response(@order, :ok, nil, { products_with_quantity: { only: %i[product_id quantity] } })
    end

    # POST /api/orders
    def create
      @order = Order.new(order_params.except(:products))
      @order.order_products.build(order_params[:products])
      if @order.save
        json_response(@order, :created, api_order_url(@order), {
                        products_with_quantity: { only: %i[product_id quantity] }
                      })
      else
        json_response(@order.errors, :unprocessable_entity)
      end
    end

    # PATCH/PUT /api/orders/1
    def update
      @order.delete_previous_products
      @order.order_products.build(order_params[:products])
      @order.assign_attributes(order_params.except(:products))
      if @order.save
        json_response(@order, :created, nil, { products_with_quantity: { only: %i[product_id quantity] } })
      else
        json_response(@order.errors, :unprocessable_entity)
      end
    end

    # DELETE /api/orders/1
    def destroy
      @order.destroy
    end

    def products
      json_response(@order.products)
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :description, :date, products: %i[product_id quantity])
    end
  end
end
