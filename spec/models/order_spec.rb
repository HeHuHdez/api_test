# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  subject(:order) { build(:order) }

  context 'with relations' do
    it { should have_many(:order_products) }
    it { should have_many(:products).through(:order_products) }
  end

  context 'with validations' do
    it { should allow_values('11:00:00', '10-10-10', Time.zone.now.to_s).for(:date) }
    it { should_not allow_value('a@a').for(:date) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  describe '.delete' do
    context 'with order_product' do
      it do
        order = create(:order_product).order
        expect { order.destroy }.to change(described_class, :count).by(-1)
                                                                   .and change(OrderProduct, :count).by(-1)
      end
    end

    context 'without order_product' do
      it do
        create_list(:order_product, 10)
        order = create(:order)
        expect { order.destroy }.to change(described_class, :count).by(-1)
                                                                   .and change(OrderProduct, :count).by(0)
      end
    end
  end
end
