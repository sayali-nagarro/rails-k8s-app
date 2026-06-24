require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    # No associations yet
  end

  describe 'validations' do
    subject { build(:product) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:sku) }
    it { should validate_uniqueness_of(:sku) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:stock_quantity).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:category) }
  end

  describe 'enums' do
    it 'defines status enum' do
      expect(Product.statuses).to eq({
        'active' => 0,
        'inactive' => 1,
        'discontinued' => 2,
        'out_of_stock' => 3
      })
    end
  end

  describe 'scopes' do
    let!(:active_product) { create(:product, status: :active, stock_quantity: 10) }
    let!(:inactive_product) { create(:product, status: :inactive, stock_quantity: 5) }
    let!(:out_of_stock_product) { create(:product, status: :active, stock_quantity: 0) }

    it 'returns only active products' do
      expect(Product.active).to include(active_product)
      expect(Product.active).not_to include(inactive_product)
    end

    it 'returns only products in stock' do
      expect(Product.in_stock).to include(active_product)
      expect(Product.in_stock).not_to include(out_of_stock_product)
    end
  end

  describe '#available?' do
    it 'returns true for active products with stock' do
      product = build(:product, status: :active, stock_quantity: 10)
      expect(product.available?).to be true
    end

    it 'returns false for inactive products' do
      product = build(:product, status: :inactive, stock_quantity: 10)
      expect(product.available?).to be false
    end

    it 'returns false for products without stock' do
      product = build(:product, status: :active, stock_quantity: 0)
      expect(product.available?).to be false
    end
  end

  describe '#update_stock' do
    let(:product) { create(:product, stock_quantity: 10) }

    it 'updates stock quantity' do
      product.update_stock(5)
      expect(product.reload.stock_quantity).to eq(15)
    end

    it 'can decrease stock' do
      product.update_stock(-3)
      expect(product.reload.stock_quantity).to eq(7)
    end
  end
end
