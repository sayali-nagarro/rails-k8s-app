require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  let!(:products) { create_list(:product, 5) }

  describe 'GET /api/v1/products' do
    it 'returns all products' do
      get '/api/v1/products'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['count']).to eq(5)
    end
  end

  describe 'GET /api/v1/products/:id' do
    it 'returns a specific product' do
      product = products.first
      get "/api/v1/products/#{product.id}"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['data']['id']).to eq(product.id)
    end

    it 'returns 404 for non-existent product' do
      get '/api/v1/products/99999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/products' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          product: {
            name: 'Test Product',
            description: 'Test Description',
            price: 99.99,
            sku: 'TEST123',
            stock_quantity: 10,
            category: 'Test Category',
            status: 'active'
          }
        }
      end

      it 'creates a new product' do
        expect {
          post '/api/v1/products', params: valid_params
        }.to change(Product, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          product: {
            name: '',
            price: -10,
            sku: ''
          }
        }
      end

      it 'returns errors' do
        post '/api/v1/products', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end

  describe 'PUT /api/v1/products/:id' do
    let(:product) { products.first }

    it 'updates a product' do
      put "/api/v1/products/#{product.id}", params: {
        product: { name: 'Updated Name' }
      }
      expect(response).to have_http_status(:success)
      expect(product.reload.name).to eq('Updated Name')
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    it 'deletes a product' do
      expect {
        delete "/api/v1/products/#{products.first.id}"
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/products/available' do
    let!(:available_product) { create(:product, status: :active, stock_quantity: 10) }
    let!(:unavailable_product) { create(:product, status: :active, stock_quantity: 0) }

    it 'returns only available products' do
      get '/api/v1/products/available'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['count']).to eq(1)
    end
  end

  describe 'GET /health' do
    it 'returns health status' do
      get '/health'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['status']).to eq('healthy')
    end
  end
end
