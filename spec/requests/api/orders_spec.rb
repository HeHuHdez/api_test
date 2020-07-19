# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Orders', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/orders' do
    get 'Index' do
      description 'Returns all orders existing orders'
      tags 'Orders'
      parameter name: :Authorization, in: :header, default: 'Token '
      parameter name: :starts, in: :query, required: false, type: :string, default: Time.current
      parameter name: :ends, in: :query, required: false, type: :string, default: Time.current
      produces 'application/json'
      before { create_list(:order_product, 5) }

      response '200', 'with valid auth_token and no filters' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }

        include_context 'with integration test'
      end

      response '200', 'with valid auth_token and starts' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:starts) { 5.days.ago.to_s }

        include_context 'with integration test'
      end

      response '200', 'with valid auth_token and ends' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:ends) { 1.day.ago.to_s }

        include_context 'with integration test'
      end

      response '422', 'with valid auth_token and invalid date format' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:ends) { '1.day.ago' }

        include_context 'with integration test'
      end

      response '200', 'with valid auth_token and both filters' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:ends) { 15.days.ago.to_s }
        let(:starts) { 30.days.ago.to_s }

        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
    end
  end

  path '/api/orders/{id}' do
    get 'Show' do
      description 'Returns an order detail'
      tags 'Orders'
      parameter name: :id, in: :path, default: 1
      parameter name: :Authorization, in: :header, default: 'Token '
      produces 'application/json'

      response '200', 'with valid auth_token and valid id' do
        let(:id) { create(:order_product).order.id }
        let(:Authorization) { "Token #{create(:user).auth_token}" }

        include_context 'with integration test'
      end

      response '404', 'with valid auth_token and invalid id' do
        let(:id) { 25_515_151 }
        let(:Authorization) { "Token #{create(:user).auth_token}" }

        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
    end
  end

  path '/api/orders' do
    post 'Create' do
      description 'Creates a new order.
      It receives all the products associated with it as an array with the keyword "products".
      It needs a product_id and a quantity in order to create a new order'
      tags 'Orders'
      parameter name: :Authorization, in: :header, default: 'Token '
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          order: {
            name: { type: :string },
            description: { type: :string },
            date: { type: :string },
            products: {
              type: :array,
              items: {
                properties: {
                  product_id: { type: :integer },
                  quantity: { type: :integer }
                }
              }
            },
            required: %w[name description date],
            example: {
              "name": 'My new product',
              "description": 'some new description',
              "date": Time.zone.now.to_s,
              "products": [
                { "product_id": 5, "quantity": 10 }
              ]
            }
          },
          required: ['order']
        }
      }
      produces 'application/json'

      response '201', 'with valid auth_token and valid params' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:product_id) { create(:product).id }
        let(:params) do
          {
            order: {
              name: 'My new product',
              description: 'some new description',
              date: Time.zone.now.to_s,
              products: {
                product_id: product_id,
                quantity: 5
              }
            }
          }
        end
        include_context 'with integration test'
      end

      response '422', 'with valid auth_token and invalid params' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:params) do
          {
            order: {
              name: nil,
              description: 'some new description',
              date: Time.zone.now.to_s
            }
          }
        end
        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
      include_context 'with bad/missing params'
    end
  end

  path '/api/orders/{id}' do
    put 'Update' do
      description 'Updates an order It receives all the products associated with it as an array with the keyword "products".
      It needs a product_id and a quantity in order to update an order'
      tags 'Orders'
      parameter name: :Authorization, in: :header, default: 'Token '
      parameter name: :id, in: :path, default: 1
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          order: {
            name: { type: :string },
            description: { type: :string },
            date: { type: :string },
            products: {
              type: :array,
              items: {
                properties: {
                  product_id: { type: :integer },
                  quantity: { type: :integer }
                }
              }
            },
            required: %w[name description date],
            example: {
              "name": 'My new product',
              "description": 'some new description',
              "date": Time.zone.now.to_s,
              "products": [
                { "product_id": 5, "quantity": 10 }
              ]
            }
          },
          required: ['order']
        }
      }
      produces 'application/json'

      response '201', 'with valid auth_token and valid params' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { create(:order).id }
        let(:product_id) { create(:product).id }
        let(:params) do
          {
            order: {
              name: 'My new product',
              description: 'some new description',
              date: Time.zone.now.to_s,
              products: {
                product_id: product_id,
                quantity: 5
              }
            }
          }
        end

        include_context 'with integration test'
      end

      response '422', 'with valid auth_token and invalid params' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { create(:order).id }
        let(:params) do
          {
            order: {
              name: nil,
              description: 'some new description',
              date: Time.zone.now.to_s
            }
          }
        end
        include_context 'with integration test'
      end

      response '404', 'with valid auth_token and invalid id' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { 25_525_252 }
        let(:params) do
          {
            order: {
              name: 'My updated product',
              description: 'updated description',
              date: Time.zone.now.to_s
            }
          }
        end

        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
      include_context 'with bad/missing params' do
        let(:id) { create(:order).id }
      end
    end
  end

  path '/api/orders/{id}' do
    delete 'Destroy' do
      description 'Destroys an order and all records associated with it'
      tags 'Orders'
      parameter name: :Authorization, in: :header, default: 'Token '
      parameter name: :id, in: :path, default: 1
      produces 'application/json'

      response '204', 'with valid auth_token and valid id' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { create(:order).id }
        run_test!
      end

      response '404', 'with valid auth_token and invalid id' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { 25_525_252 }

        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
    end
  end

  path '/api/orders/{id}/products' do
    get 'Products from order' do
      description 'Get all the '
      tags 'Orders'
      parameter name: :Authorization, in: :header, default: 'Token '
      parameter name: :id, in: :path, default: 1
      produces 'application/json'

      response '200', 'with valid auth_token and valid id' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { create(:order_product).order.id }

        include_context 'with integration test'
      end

      response '404', 'with valid auth_token and invalid id' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { 25_525_252 }

        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
    end
  end
end
