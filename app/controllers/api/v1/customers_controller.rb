class Api::V1::CustomersController < ApplicationController
  before_action :set_customer, only: [ :show, :update, :destroy ]

  def index
    customers = Customer.includes(:sales, :payments)
    render json: customers.map { |c| customer_json(c) }
  end

  def show
    render json: customer_json(@customer)
  end

  def create
    customer = Customer.new(customer_params)
    if customer.save
      customer = Customer.includes(:sales, :payments).find(customer.id)
      render json: customer_json(customer), status: :created
    else
      render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params)
      render json: customer_json(@customer)
    else
      render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    render json: {}, status: :no_content
  end

  private

  def set_customer
    @customer = Customer.includes(:sales, :payments).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Cliente no encontrado" }, status: :not_found
  end

  def customer_params
    params.require(:customer).permit(:name, :phone, :notes)
  end

  def customer_json(c)
    CustomerSerializer.new(c).as_json
  end
end
