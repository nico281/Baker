# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [ :create ]

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: "Usuario creado",
        user: { id: resource.id, email: resource.email }
      }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
