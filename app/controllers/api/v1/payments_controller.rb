class Api::V1::PaymentsController < ApplicationController
  before_action :set_customer
  before_action :set_payment, only: [ :show, :update, :destroy ]

  def index
    customers = Customer.includes(:sales, :payments).all
    render json: customers.map { |c|
      c.as_json.merge(
        total_sales: c.sales.sum(&:amount),
        total_payments: c.payments.sum(&:amount),
        balance: total_salses - total_payments
      )
    }
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
      params.require(:payment).permit(:amount, :notes)
  end
end
