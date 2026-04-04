class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: "Recurso no encontrado" }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  rescue_from StandardError do |e|
    render json: { error: "Error interno" }, status: :internal_server_error
  end
end
