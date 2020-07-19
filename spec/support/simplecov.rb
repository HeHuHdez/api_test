# frozen_string_literal: true

require 'simplecov'
RSpec.configure do
  SimpleCov.start 'rails' do
    add_filter '/bin/'
    add_filter '/db/'
    add_filter '/spec/' # for rspec
  end
end
