# frozen_string_literal: true

require 'rails_helper'

shared_context 'with expired/wrong auth_token' do
  response '401', 'invalid token' do
    let(:Authorization) { 'Token thisisfaketoken' }
    let(:id) { 1 }
    let(:params) { nil }
    run_test!
  end
end
