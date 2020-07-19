# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::Products', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/products' do
    get 'Index' do
      description 'Returns all existing products'
      tags 'Products'
      parameter name: :Authorization, in: :header, default: 'Token '
      produces 'application/json'
      before { create_list(:product, 10) }

      response '200', 'with valid auth_token' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }

        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
    end
  end

  path '/api/products/{id}' do
    get 'Show' do
      description 'Returns a product detail'
      tags 'Products'
      parameter name: :id, in: :path, default: 1
      parameter name: :Authorization, in: :header, default: 'Token '
      produces 'application/json'

      response '200', 'with valid auth_token and valid id' do
        let(:id) { create(:product).id }
        let(:Authorization) { "Token #{create(:user).auth_token}" }

        include_context 'with integration test'
      end

      response '404', 'with valid auth_token and invalid id' do
        let(:id) { 12 }
        let(:Authorization) { "Token #{create(:user).auth_token}" }

        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
    end
  end

  path '/api/products' do
    post 'Create' do
      description 'Creates a new product '
      tags 'Products'
      parameter name: :Authorization, in: :header, default: 'Token '
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            name: { type: :string },
            description: { type: :string },
            required: %w[name description],
            example: {
              "name": 'My new product',
              "description": 'some new description'
            }
          },
          required: ['product']
        }
      }
      produces 'application/json'

      response '201', 'with valid auth_token and valid params' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:params) do
          {
            product: {
              name: 'My new product',
              description: 'some new description'
            }
          }
        end
        include_context 'with integration test'
      end

      response '422', 'with valid auth_token and invalid params' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:params) do
          {
            product: {
              name: nil,
              description: 'some new description'
            }
          }
        end
        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
    end
  end

  path '/api/products/{id}' do
    put 'Update' do
      description 'Updates a product '
      tags 'Products'
      parameter name: :Authorization, in: :header, default: 'Token '
      parameter name: :id, in: :path, default: 1
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            name: { type: :string },
            description: { type: :string },
            required: %w[name description],
            example: {
              "name": 'My updated product',
              "description": 'Updated description'
            }
          },
          required: ['product']
        }
      }
      produces 'application/json'

      response '200', 'with valid auth_token and valid params' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { create(:product).id }
        let(:params) do
          {
            product: {
              name: 'My updated product',
              description: 'updated description'
            }
          }
        end
        include_context 'with integration test'
      end

      response '422', 'with valid auth_token and invalid params' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { create(:product).id }
        let(:params) do
          {
            product: {
              name: nil,
              description: 'some new description'
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
            product: {
              name: 'My updated product',
              description: 'updated description'
            }
          }
        end

        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
    end
  end

  path '/api/products/{id}' do
    delete 'Destroy' do
      description 'Destroys a product and all records associated with it'
      tags 'Products'
      parameter name: :Authorization, in: :header, default: 'Token '
      parameter name: :id, in: :path, default: 1
      produces 'application/json'

      response '204', 'with valid auth_token and valid id' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:id) { create(:product).id }
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

  path '/api/products/populars' do
    get 'Populars' do
      description 'Returns all products with an order sorted by the quantity they have.
      It can be delimeted with the limit param'
      tags 'Products'
      parameter name: :Authorization, in: :header, default: 'Token '
      parameter name: :limit, in: :query, type: :string, required: false
      produces 'application/json'

      before { create_list(:order_product, 10) }

      response '200', 'with valid auth_token and limit' do
        let(:Authorization) { "Token #{create(:user).auth_token}" }
        let(:limit) { 3 }

        include_context 'with integration test'
      end

      include_context 'with expired/wrong auth_token'
    end
  end
end
