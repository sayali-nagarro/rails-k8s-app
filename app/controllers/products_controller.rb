class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    products = Product.all
    render json: {
      data: products,
      count: products.count,
      status: 'success'
    }
  end

  def show
    render json: {
      data: @product,
      status: 'success'
    }
  end

  def create
    product = Product.new(product_params)

    if product.save
      render json: {
        data: product,
        status: 'success',
        message: 'Product created successfully'
      }, status: :created
    else
      render json: {
        errors: product.errors.full_messages,
        status: 'error'
      }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: {
        data: @product,
        status: 'success',
        message: 'Product updated successfully'
      }
    else
      render json: {
        errors: @product.errors.full_messages,
        status: 'error'
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    render json: {
      status: 'success',
      message: 'Product deleted successfully'
    }, status: :ok
  end

  def available
    products = Product.active.in_stock
    render json: {
      data: products,
      count: products.count,
      status: 'success'
    }
  end

  def by_category
    category = params[:category]
    products = Product.by_category(category)
    render json: {
      data: products,
      count: products.count,
      category: category,
      status: 'success'
    }
  end

  def health
    render json: {
      status: 'healthy',
      timestamp: Time.now.utc.iso8601,
      database: ActiveRecord::Base.connection.active? ? 'connected' : 'disconnected'
    }
  end

  def metrics
    # Expose metrics for HPA
    response = {
      timestamp: Time.now.utc.iso8601,
      products_count: Product.count,
      active_products: Product.active.count,
      total_stock: Product.sum(:stock_quantity)
    }
    render json: response
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      error: 'Product not found',
      status: 'error'
    }, status: :not_found
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :sku,
      :stock_quantity, :category, :status
    )
  end
end
