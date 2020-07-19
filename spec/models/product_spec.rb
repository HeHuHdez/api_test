# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  subject(:product) { build(:product) }

  context 'with relations' do
    it { should have_many(:order_products) }
    it { should have_many(:orders).through(:order_products) }
  end

  context 'with validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_uniqueness_of(:name) }
  end

  describe '.delete' do
    context 'with order_product' do
      it do
        product = create(:order_product).product
        expect { product.destroy }.to change(described_class, :count).by(-1)
                                                                     .and change(OrderProduct, :count).by(-1)
      end
    end

    context 'without order_product' do
      it do
        create_list(:order_product, 10)
        product = create(:product)
        expect { product.destroy }.to change(described_class, :count).by(-1)
                                                                     .and change(OrderProduct, :count).by(0)
      end
    end
  end
end
