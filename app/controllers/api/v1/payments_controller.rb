class Api::V1::PaymentsController < ApplicationController
  before_action :set_customer
  before_action :set_payment, only: [ :show, :update, :destroy ]

  def index
    render json: @customer.payments.recent
  end

  def show
    render json: @payment
  end

  def create
    payment = @customer.payments.new(payment_params)
    if payment.save
      render json: payment, status: :created
    else
      render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @payment.update(payment_params)
      render json: @payment
    else
      render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @payment.destroy
    render json: {}, status: :no_content
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cliente no encontrado" }, status: :not_found
  end

  def set_payment
    @payment = @customer.payments.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Pago no encontrado" }, status: :not_found
  end

  def payment_params
    @payment.require(:payment).permit(:amount, :notes)
  end
end
