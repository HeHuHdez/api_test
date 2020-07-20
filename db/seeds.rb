User.create(name: 'Api test', email: 'apitest@test.com', password: 'apitest123', password_confirmation: 'apitest123')
10.times do |n|
  product = Product.create(name: "Product #{n}", description: "Description #{n}")
  order = Order.create(name: "Order #{n}", description: "Description #{n}", date: Time.current)
  OrderProduct.create(order: order, product: product, quantity: rand(1..100))
end