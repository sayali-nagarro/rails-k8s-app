FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 10.0..500.0) }
    sku { Faker::Alphanumeric.alphanumeric(number: 8).upcase }
    stock_quantity { 0 }
    category { Faker::Commerce.department }
    status { :inactive }
  end

  trait :inactive do
    status { :inactive }
  end

  trait :discontinued do
    status { :discontinued }
  end

  trait :out_of_stock do
    stock_quantity { 0 }
    status { :out_of_stock }
  end
end
