# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      swagger: '2.0',
      info: {
        title: 'API V1. Documentation for Api Test',
        version: 'v1'
      },
      securitySchemes: {
        basic_auth: {
          type: :http,
          scheme: :basic
        }
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ]
    }
  }

  config.swagger_format = :yaml
end
