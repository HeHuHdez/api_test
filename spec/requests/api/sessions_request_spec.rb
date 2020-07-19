# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::Sessions', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/sessions' do
    post 'Login method' do
      description 'The user should provide his/hers email and password.
      The request will return the auth_token needed to authorize the other requests'
      tags 'Sessions'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          required: %w[email password]
        }
      }
      produces 'application/json'

      let(:user) { create(:user) }

      response '200', 'with valid user credentials' do
        let(:params) { { email: user.email, password: 'apitest123' } }

        include_context 'with integration test'
      end

      response '401', 'with invalid user credentials' do
        let(:params) { { email: user.email, password: 'password' } }

        include_context 'with integration test'
      end
    end
  end
end
