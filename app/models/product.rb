# frozen_string_literal: true

# Product class
class Product < ApplicationRecord
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products

  validates :name, :description, presence: true
  validates :name, uniqueness: true

  scope :total_orders, lambda {
    joins(:order_products)
      .group('products.name')
      .sum('order_products.quantity')
  }

  def as_json(options = nil)
    super({ except: %i[created_at updated_at] }.merge(options || {}))
  end
end
