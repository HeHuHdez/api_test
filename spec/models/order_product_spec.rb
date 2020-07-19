# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderProduct, type: :model do
  subject(:order_product) { build(:order_product) }

  context 'with relations' do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end

  context 'with validations' do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_uniqueness_of(:order_id).scoped_to(:product_id) }
  end
end
