# frozen_string_literal: true

# Join model for order products
class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :order_id, uniqueness: { scope: :product_id }
end
