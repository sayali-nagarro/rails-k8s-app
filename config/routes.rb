Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "products/available", to: "products#available"
      resources :products
      get "products/category/:category", to: "products#by_category"
      get "health", to: "products#health"
      get "metrics", to: "products#metrics"
    end
  end

  # Health check for Kubernetes
  get "/health", to: "products#health"
  get "/metrics", to: "products#metrics"
end
