class Api::V1::CustomersController < ApplicationController
  before_action :set_customer, only: [ :show, :update, :destroy ]

   def index
    render json: Customer.all
   end

  def show
    render json: @customer
  end

  def create
    customer = Customer.create(customer_params)
    render json: customer, status: :created
  end

  def update
    @customer.update(customer_params)
    render json: @customer
  end

  def destroy
    @customer.destroy
      render json: @customer, status: no_content
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :phone, :notes)
  end
end
