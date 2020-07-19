# frozen_string_literal: true

require 'rails_helper'

shared_context 'with bad/missing params' do
  response '400', 'missing params' do
    let(:Authorization) { "Token #{create(:user).auth_token}" }
    let(:params) { nil }
    run_test!
  end
end
