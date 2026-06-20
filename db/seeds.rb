# Clear existing data
Product.destroy_all

products = [
  {
    name: "Premium Wireless Headphones",
    description: "High-quality wireless headphones with noise cancellation and 30-hour battery life.",
    price: 199.99,
    sku: "WH-001",
    stock_quantity: 50,
    category: "Electronics",
    status: 0
  },
  {
    name: "Organic Cotton T-Shirt",
    description: "Comfortable organic cotton t-shirt, available in multiple colors.",
    price: 29.99,
    sku: "CT-002",
    stock_quantity: 150,
    category: "Clothing",
    status: 0
  },
  {
    name: "Stainless Steel Water Bottle",
    description: "Eco-friendly insulated water bottle, keeps drinks cold for 24 hours.",
    price: 34.99,
    sku: "WB-003",
    stock_quantity: 75,
    category: "Home & Kitchen",
    status: 0
  },
  {
    name: "Wireless Charging Pad",
    description: "Fast wireless charging pad compatible with all Qi-enabled devices.",
    price: 49.99,
    sku: "CP-004",
    stock_quantity: 30,
    category: "Electronics",
    status: 1
  },
  {
    name: "Leather Wallet",
    description: "Premium genuine leather wallet with RFID blocking technology.",
    price: 79.99,
    sku: "LW-005",
    stock_quantity: 45,
    category: "Accessories",
    status: 0
  },
  {
    name: "Smart Watch Series 5",
    description: "Advanced smartwatch with health monitoring, GPS, and 5-day battery life.",
    price: 299.99,
    sku: "SW-006",
    stock_quantity: 25,
    category: "Electronics",
    status: 0
  },
  {
    name: "Yoga Mat Premium",
    description: "Non-slip, eco-friendly yoga mat with alignment guides.",
    price: 59.99,
    sku: "YM-007",
    stock_quantity: 80,
    category: "Sports & Fitness",
    status: 0
  },
  {
    name: "Coffee Maker Pro",
    description: "Programmable coffee maker with thermal carafe and 12-cup capacity.",
    price: 149.99,
    sku: "CM-008",
    stock_quantity: 20,
    category: "Home & Kitchen",
    status: 0
  },
  {
    name: "Bluetooth Speaker Mini",
    description: "Portable waterproof Bluetooth speaker with 360° sound.",
    price: 89.99,
    sku: "BS-009",
    stock_quantity: 60,
    category: "Electronics",
    status: 2
  },
  {
    name: "Desk Organizer Set",
    description: "Complete desk organization set with pen holder, file sorter, and tray.",
    price: 39.99,
    sku: "DO-010",
    stock_quantity: 100,
    category: "Office Supplies",
    status: 0
  }
]

products.each do |product_data|
  Product.create!(product_data)
end

puts "Created #{Product.count} products"
