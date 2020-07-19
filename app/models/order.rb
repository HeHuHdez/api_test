# frozen_string_literal: true

# Order class
class Order < ApplicationRecord
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  validates :name, :description, :date, presence: true

  scope :from_to, lambda { |start_date, end_date|
    start_date ||= DateTime.new
    end_date ||= DateTime::Infinity.new
    start_date = Time.zone.parse(start_date) unless start_date.is_a?(DateTime)
    end_date = Time.zone.parse(end_date) unless end_date.is_a?(Date::Infinity)
    where(date: start_date..end_date)
  }

  def delete_previous_products
    order_products.destroy_all
  end

  def products_with_quantity
    products.select('products.id as product_id, order_products.quantity as quantity')
  end

  def as_json(options = nil)
    super({ except: %i[created_at updated_at] }.merge(options || {}))
  end
end
