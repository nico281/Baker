# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      message: "Login exitoso",
      user: { id: resource.id, email: resource.email }
    }, status: :ok
  end

  def respond_to_on_destroy
    render json: { message: "Logout exitoso" }, status: :ok
  end
end
