class Product < ApplicationRecord
  enum :status, {
    active: 0,
    inactive: 1,
    discontinued: 2,
    out_of_stock: 3
  }

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :sku, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true

  scope :active, -> { where(status: :active) }
  scope :in_stock, -> { where("stock_quantity > ?", 0) }
  scope :by_category, ->(category) { where(category: category) if category.present? }

  def available?
    active? && stock_quantity > 0
  end

  def update_stock(quantity)
    update_column(:stock_quantity, stock_quantity + quantity)
  end
end
