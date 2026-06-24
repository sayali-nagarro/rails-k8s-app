class ApplicationController < ActionController::API
  rescue_from StandardError do |exception|
    render json: {
      error: exception.message,
      status: "error"
    }, status: :internal_server_error
  end
end
